//
//  AllChatsViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - AllChatsViewModelProtocol

protocol AllChatsViewModelProtocol: AnyObject {
    // MARK: Network
    func getUserMessages() async throws -> [FBChatMessageModel]
    // MARK: Lifecycle
    func onAppear()
    // MARK: Action
    func didTapCell(with cellInfo: ChatCellModel)
    // MARK: Memory
    func saveUser(fbUser: FBUserModel)
    func saveMessages(messages: [FBChatMessageModel])
    func fetchMessages() async -> [ChatCellModel]
    // MARK: Reducers
    func setReducers(modelContext: ModelContext, root: RootViewModel, nav: Navigation)
}

// MARK: - AllChatsViewModel

@Observable
final class AllChatsViewModel: ViewModelProtocol, AllChatsViewModelProtocol {

    var uiProperties: UIProperties
    private(set) var chatCells: [ChatCellModel]
    private let services: Services
    private var reducers: Reducers

    init(
        chatCells: [ChatCellModel] = [],
        services: Services = .clear,
        uiProperties: UIProperties = .clear,
        reducers: Reducers = .clear
    ) {
        self.chatCells = chatCells
        self.services = services
        self.uiProperties = uiProperties
        self.reducers = reducers
    }

    // MARK: Computed Properties

    var filterInputText: [ChatCellModel] {
        uiProperties.searchText.isEmpty
        ? chatCells
        : chatCells.filter {
            $0.user.nickname.lowercased().contains(uiProperties.searchText.lowercased().trimmingCharacters(in: .whitespaces))
        }
    }
    private var currentUser: FBUserModel { reducers.root.currentUser }
    private var currentUserID: String { currentUser.uid }
}

// MARK: - Network

extension AllChatsViewModel {

    func getUserMessages() async throws -> [FBChatMessageModel] {
        try await services.chatService.fetchUserMessages(userID: reducers.root.currentUser.uid)
    }
}

// MARK: - Lifecycle

extension AllChatsViewModel {

    @MainActor
    func onAppear() {
        guard chatCells.isEmpty else { return }
        uiProperties.showLoader = true

        // Достаём данные из памяти устройства
        Task {
            chatCells = await fetchMessages()
            if !uiProperties.showLoader { return }
            withAnimation {
                uiProperties.showLoader = false
            }
        }

        // Получаем данные из сети
        Task {
            let userMessages = try await getUserMessages()

            // Кэшируем сообщения в памяти устройства
            saveMessages(messages: userMessages)

            chatCells = await assembleMessagesInfoCells(messages: userMessages)
            if !uiProperties.showLoader { return }
            withAnimation {
                uiProperties.showLoader = false
            }
        }
    }

    /// Получение сообщения из Web Socket слоя
    func receiveMessage(output: NotificationCenter.Publisher.Output) {
        guard
            let wsMessage = output.object as? WSMessage, wsMessage.kind == .message,
            let index = chatCells.firstIndex(where: { $0.user.id == wsMessage.userID })
        else {
            return
        }
        let newMessage = ChatCellModel.Message(
            id: wsMessage.id,
            time: wsMessage.dispatchDate,
            text: wsMessage.message,
            isYou: wsMessage.userID == currentUserID
        )
        chatCells[index].lastMessage = newMessage.text
        chatCells[index].messages.append(newMessage)
    }
}

// MARK: - Action

extension AllChatsViewModel {

    func didTapCell(with cellInfo: ChatCellModel) {
        let messages: [ChatMessage] = cellInfo.messages.map { message in
            let messageUserName: String = message.isYou ? currentUser.nickname : cellInfo.user.nickname
            let messageUserImage = message.isYou
            ? .string(currentUser.avatarImage ?? .clear)
            : cellInfo.user.imageKind

            return ChatMessage(
                id: message.id,
                isYou: message.isYou,
                message: message.text,
                user: .init(
                    name: messageUserName,
                    image: messageUserImage
                ),
                time: message.time?.formattedString(format: Constants.dateFormattedString) ?? .clear,
                state: .received
            )
        }

        var user: ChatCellModel.User { cellInfo.user }
        reducers.nav.addScreen(
            screen: Screens.chat(
                messages: messages,
                interlocutor: .init(
                    id: user.id,
                    image: user.imageKind,
                    nickname: user.nickname
                )
            )
        )
    }
}

// MARK: - Memory

extension AllChatsViewModel {

    /// Кэшируем пользователя чата, если он ещё не существует
    func saveUser(fbUser: FBUserModel) {
        let sdUser = SDUserModel(fbModel: fbUser)
        reducers.modelContext.insert(sdUser)
        try? reducers.modelContext.save()
    }

    /// Кэшируем все сообщения
    func saveMessages(messages: [FBChatMessageModel]) {
        messages.forEach { message in
            let sdMessage = SDChatMessageModel(fbModel: message)
            reducers.modelContext.insert(sdMessage)
        }
        try? reducers.modelContext.save()
    }

    @MainActor
    /// Достаем истории чатов со всеми пользователями
    func fetchMessages() async -> [ChatCellModel] {
        // Достаём сообщения из памяти устройства
        let fetchDescriptor = FetchDescriptor<SDChatMessageModel>()
        guard let messages = try? reducers.modelContext.fetch(fetchDescriptor) else {
            return []
        }
        let fbMessages = messages.map { $0.mapper }

        // Получаем уникальных пользователей
        let usersIDsSet = getAllInterlocutorsIDs(messages: fbMessages)

        // Асинхронно группируем по ячейкам чата
        async let chatMessages = interlocutorsMessages(
            usersIDsSet: usersIDsSet,
            messages: fbMessages
        )

        // Дожидаемся выполнения задачи группировки и получения данных пользоветлей из памяти устройства
        let result = await (fetchUsersInfoFromMemory(userIDsSet: usersIDsSet), chatMessages)

        // Мёржим данные пользователей и истории сообщений
        let chatCells: [ChatCellModel] = result.0.compactMap { fbUser in
            guard let chatCell = result.1.first(where: { $0.user.id == fbUser.uid }) else {
                return nil
            }
            return ChatCellModel(
                user: .init(
                    id: fbUser.uid,
                    nickname: fbUser.nickname,
                    imageKind: .string(fbUser.avatarImage ?? .clear)
                ),
                lastMessage: chatCell.lastMessage,
                timeMessage: chatCell.timeMessage,
                messages: chatCell.messages
            )
        }

        let sortedCells = sortCellsByDate(chatCells)
        return sortedCells
    }

    @MainActor
    /// Достаём информацию о пользователях из памяти устройства
    func fetchUsersInfoFromMemory(userIDsSet: Set<String>) -> [FBUserModel] {
        let sdUsers = userIDsSet.compactMap { userID in
            let predicate = #Predicate<SDUserModel> { $0._id == userID }
            let fetchDescriptor = FetchDescriptor(predicate: predicate)
            return (try? reducers.modelContext.fetch(fetchDescriptor))?.first
        }
        return sdUsers.map { $0.mapper }
    }
}

// MARK: - Reducers

extension AllChatsViewModel {

    func setReducers(modelContext: ModelContext, root: RootViewModel, nav: Navigation) {
        reducers.modelContext = modelContext
        reducers.root = root
        reducers.nav = nav
    }
}

// MARK: - Private Logic

private extension AllChatsViewModel {

    /// Получаем собеседников и полную историю сообщений с ним
    func assembleMessagesInfoCells(messages: [FBChatMessageModel]) async -> [ChatCellModel] {
        let usersIDsSet = getAllInterlocutorsIDs(messages: messages)

        let chatCells = await withTaskGroup(
            of: [ChatCellModel].self,
            returning: [ChatCellModel].self
        ) { taskGroup -> [ChatCellModel] in
            taskGroup.addTask {
                await self.getUsersInfo(usersIDsSet: usersIDsSet)
            }
            taskGroup.addTask {
                await self.interlocutorsMessages(usersIDsSet: usersIDsSet, messages: messages)
            }

            var chatCellsArray: [[ChatCellModel]] = []
            for await task in taskGroup {
                chatCellsArray.append(task)
            }
            let chatCells = chatCellsArray.flatMap { $0 }

            // По результату выполнения обеих задач у нас будет массив одинаковых ячеек чата.
            // Один массив будет содержать информацию о пользователе из интернета, но не будет содержать историю чата.
            // Второй будет содержать историю чата, но не будет содержать информацию об пользователе из интернета.
            // Задача смёржить все эти две ячейки в одну полноценную.
            var mergedChatCells: [ChatCellModel] = []
            for chatCell in chatCells {
                // Если в массиве уже есть ячейка с текущим ID, значит надо дополнить вторую часть информации по ней
                // Иначе это только первая часть информации и мы просто добавляем её в массив и идём дальше
                guard let oldChatCellIndex = mergedChatCells.firstIndex(where: { $0.user.id == chatCell.user.id }) else {
                    mergedChatCells.append(chatCell)
                    continue
                }

                let oldChatCell = mergedChatCells[oldChatCellIndex]
                let user = oldChatCell.user.nickname.isEmpty ? chatCell.user : oldChatCell.user
                let lastMessage = oldChatCell.lastMessage.isEmpty ? chatCell.lastMessage : oldChatCell.lastMessage
                let timeMessage = oldChatCell.timeMessage.isNil ? chatCell.timeMessage : oldChatCell.timeMessage
                let messages = oldChatCell.messages.isEmpty ? chatCell.messages : oldChatCell.messages

                let newChatCell = ChatCellModel(
                    user: user,
                    lastMessage: lastMessage,
                    timeMessage: timeMessage,
                    messages: messages
                )
                mergedChatCells[oldChatCellIndex] = newChatCell
            }

            let sortedCells = sortCellsByDate(mergedChatCells)
            return sortedCells
        }

        return chatCells
    }

    /// Фильтруем уникальных пользователей
    func getAllInterlocutorsIDs(messages: [FBChatMessageModel]) -> Set<String> {
        var usersIDsSet: Set<String> = Set()
        for message in messages {
            usersIDsSet.insert(message.receiverID)
            usersIDsSet.insert(message.userID)
        }

        return usersIDsSet
    }

    /// Получаем данные пользователей
    func getUsersInfo(usersIDsSet: Set<String>) async -> [ChatCellModel] {
        let usersCells = await withThrowingTaskGroup(
            of: FBUserModel?.self,
            returning: [ChatCellModel].self
        ) { taskGroup in
            for userID in usersIDsSet {
                taskGroup.addTask { [weak self] in
                    try? await self?.services.userService.getUserInfo(uid: userID)
                }
            }

            var users: [ChatCellModel] = []
            while let userInfo = try? await taskGroup.next() {
                guard let userInfo else { continue }

                // Кэшируем пользователя в памяти устройства
                await MainActor.run {
                    self.saveUser(fbUser: userInfo)
                }

                let user: ChatCellModel.User = .init(
                    id: userInfo.uid,
                    nickname: userInfo.nickname,
                    imageKind: .string(userInfo.avatarImage ?? .clear)
                )
                let chatCell = ChatCellModel(user: user)
                users.append(chatCell)
            }
            return users
        }

        return usersCells
    }

    /// Получаем сообщения текущего пользователя с уникальными собеседниками
    func interlocutorsMessages(
        usersIDsSet: Set<String>,
        messages: [FBChatMessageModel]
    ) async -> [ChatCellModel] {
        var chatsMessages: [ChatCellModel] = []
        for userID in usersIDsSet {
            // Фильтруем сообщения только текущего пользователя и собеседника
            let theirMessages = messages.filter {
                ($0.receiverID == userID && $0.userID == currentUserID) || ($0.userID == userID && $0.receiverID == currentUserID)
            }

            // Сортируем сообщения по дате отправления
            let sortedMessages = sortMessagesByDate(theirMessages).map {
                ChatCellModel.Message(
                    id: $0.id,
                    time: $0.dispatchDate.dateRedescription,
                    text: $0.message,
                    isYou: $0.userID == currentUserID
                )
            }

            let lastMessageInfo = sortedMessages.last
            let chatCell = ChatCellModel(
                user: .init(id: userID),
                lastMessage: lastMessageInfo?.text ?? Constants.emptyCellSubtitleForInterlacutor,
                timeMessage: lastMessageInfo?.time,
                messages: sortedMessages
            )
            chatsMessages.append(chatCell)
        }

        return chatsMessages
    }

    /// Сортируем сообщение по дате
    func sortMessagesByDate(_ messages: [FBChatMessageModel]) -> [FBChatMessageModel] {
        let sortedDates = messages.sorted { msg1, msg2 in
            let date1 = msg1.dispatchDate.dateRedescription
            let date2 = msg2.dispatchDate.dateRedescription

            if let date1, let date2 {
                return date1 < date2
            } else {
                return false
            }
        }
        return sortedDates
    }

    func sortCellsByDate(_ cells: [ChatCellModel]) -> [ChatCellModel] {
        let sortedCells = cells.sorted { cell1, cell2 in
            let date1 = cell1.timeMessage
            let date2 = cell2.timeMessage

            if let date1, let date2 {
                return date1 > date2
            } else {
                return true
            }
        }

        // Переставляем ячейку текущего пользователя на самый вверх
        var currentUserCell: ChatCellModel?
        var cellsWithoutCurrentUser = sortedCells.compactMap { cell in
            guard cell.user.id == currentUserID else {
                return cell
            }
            currentUserCell = cell
            return nil
        }
        guard var currentUserCell else { return sortedCells }
        currentUserCell.user.nickname = Constants.emptyCellTitleForYou
        cellsWithoutCurrentUser.insert(currentUserCell, at: 0)
        return cellsWithoutCurrentUser
    }
}

// MARK: - Constants

private extension AllChatsViewModel {

    enum Constants {
        static let emptyCellSubtitleForInterlacutor = String(localized: "Message history is empty")
        static let emptyCellTitleForYou = String(localized: "It's you! 😝")
        static let dateFormattedString = "HH:mm"
    }
}
