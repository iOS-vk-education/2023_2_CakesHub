//
//  AllChatsViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import SwiftData

// MARK: - AllChatsViewModelProtocol

protocol AllChatsViewModelProtocol: AnyObject {}

// MARK: - AllChatsViewModel

@Observable
final class AllChatsViewModel: ViewModelProtocol, AllChatsViewModelProtocol {

    var uiProperties: UIProperties
    private(set) var chatCells: [ChatCellIModel]
    private let services: Services
    private var reducers: Reducers

    init(
        chatCells: [ChatCellIModel] = [],
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

    var filterInputText: [ChatCellIModel] {
        uiProperties.searchText.isEmpty
        ? chatCells
        : chatCells.filter { $0.userName.lowercased().contains(uiProperties.searchText.lowercased().trimmingCharacters(in: .whitespaces)) }
    }

    private var currentUserID: String { reducers.root.currentUser.uid }
}

// MARK: - Network

extension AllChatsViewModel {

    func getUserMessages() async throws -> [FBChatMessageModel] {
        try await services.chatService.fetchUserMessages(userID: reducers.root.currentUser.uid)
    }
}

// MARK: - Lifecycle

extension AllChatsViewModel {

    func onAppear() {
        guard chatCells.isEmpty else { return }
        Task {
            uiProperties.showLoader = true
            let userMessages = try await getUserMessages()
            chatCells = await assembleMessagesInfoCells(messages: userMessages)
            uiProperties.showLoader = false
        }
    }
}

// MARK: - Reducers

extension AllChatsViewModel {

    func setReducers(modelContext: ModelContext, root: RootViewModel) {
        reducers.modelContext = modelContext
        reducers.root = root
    }
}

// MARK: - Private Logic

extension AllChatsViewModel {

    /// Получаем собеседников и полную историю сообщений с ним
    func assembleMessagesInfoCells(messages: [FBChatMessageModel]) async -> [ChatCellIModel] {
        let usersIDsSet = getAllInterlocutorsIDs(messages: messages)

        let chatCells = await withTaskGroup(
            of: [ChatCellIModel].self,
            returning: [ChatCellIModel].self
        ) { taskGroup -> [ChatCellIModel] in
            taskGroup.addTask {
                await self.getUsersInfo(usersIDsSet: usersIDsSet)
            }
            taskGroup.addTask {
                await self.interlocutorsMessages(usersIDsSet: usersIDsSet, messages: messages)
            }

            var chatCellsArray: [[ChatCellIModel]] = []
            for await task in taskGroup {
                chatCellsArray.append(task)
            }
            let chatCells = chatCellsArray.flatMap { $0 }

            // По результату выполнения обеих задач у нас будет массив одинаковых ячеек чата.
            // Один массив будет содержать информацию о пользователе из интернета, но не будет содержать историю чата.
            // Второй будет содержать историю чата, но не будет содержать информацию об пользователе из интернета.
            // Задача смёржить все эти две ячейки в одну полноценную.
            var mergedChatCells: [ChatCellIModel] = []
            for chatCell in chatCells {
                // Если в массиве уже есть ячейка с текущим ID, значит надо дополнить вторую часть информации по ней
                // Иначе это только первая часть информации и мы просто добавляем её в массив и идём дальше
                guard let oldChatCellIndex = mergedChatCells.firstIndex(where: { $0.userID == chatCell.userID }) else {
                    mergedChatCells.append(chatCell)
                    continue
                }

                let oldChatCell = mergedChatCells[oldChatCellIndex]
                let userName = oldChatCell.userName.isEmpty ? chatCell.userName : oldChatCell.userName
                let imageKind = oldChatCell.imageKind.isClear ? chatCell.imageKind : oldChatCell.imageKind
                let lastMessage = oldChatCell.lastMessage.isEmpty ? chatCell.lastMessage : oldChatCell.lastMessage
                let timeMessage = oldChatCell.timeMessage.isEmpty ? chatCell.timeMessage : oldChatCell.timeMessage
                let messages = oldChatCell.messages.isEmpty ? chatCell.messages : oldChatCell.messages

                let newChatCell = ChatCellIModel(
                    userID: oldChatCell.userID,
                    userName: userName,
                    imageKind: imageKind,
                    lastMessage: lastMessage,
                    timeMessage: timeMessage,
                    messages: messages
                )
                mergedChatCells[oldChatCellIndex] = newChatCell
            }

            return mergedChatCells
        }

        return chatCells
    }

    /// Фильтруем уникальных пользователей
    func getAllInterlocutorsIDs(messages: [FBChatMessageModel]) -> Set<String> {
        var usersIDsSet: Set<String> = Set()
        for message in messages {
            usersIDsSet.insert(message.receiverID)
        }

        return usersIDsSet
    }

    /// Получаем данные пользователей
    func getUsersInfo(usersIDsSet: Set<String>) async -> [ChatCellIModel] {
        let usersCells = await withThrowingTaskGroup(
            of: FBUserModel?.self,
            returning: [ChatCellIModel].self
        ) { taskGroup in
            for userID in usersIDsSet {
                taskGroup.addTask { [weak self] in
                    try? await self?.services.userService.getUserInfo(uid: userID)
                }
            }

            var users: [ChatCellIModel] = []
            while let userInfo = try? await taskGroup.next() {
                guard let userInfo else { continue }
                let chatCell = ChatCellIModel(
                    userID: userInfo.uid,
                    userName: userInfo.nickname,
                    imageKind: .url(URL(string: userInfo.avatarImage ?? .clear))
                )
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
    ) async -> [ChatCellIModel] {
        var chatsMessages: [ChatCellIModel] = []
        for userID in usersIDsSet {
            if userID == currentUserID {
                let chatCell = ChatCellIModel(
                    userID: userID,
                    lastMessage: Constants.emptyCellSubtitleForYou
                )
                chatsMessages.append(chatCell)
                continue
            }

            // Фильтруем сообщения только текущего пользователя и собеседника
            let theirMessages = messages.filter {
                ($0.receiverID == userID && $0.userID == currentUserID) || ($0.userID == currentUserID && $0.receiverID == userID)
            }

            // Сортируем сообщения по дате отправления
            let sortedMessages = sortMessagesByDate(theirMessages).map {
                ChatCellIModel.Message(
                    id: $0.id,
                    time: $0.dispatchDate.dateRedescription?.formattedString(format: Constants.dateFormattedString) ?? .clear,
                    text: $0.message
                )
            }

            let lastMessageInfo = sortedMessages.last
            let chatCell = ChatCellIModel(
                userID: userID,
                userName: .clear,
                imageKind: .clear,
                lastMessage: lastMessageInfo?.text ?? Constants.emptyCellSubtitleForInterlator,
                timeMessage: lastMessageInfo?.time ?? .clear,
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
}

// MARK: - Constants

private extension AllChatsViewModel {

    enum Constants {
        static let emptyCellSubtitleForInterlator = "История сообщений пуста"
        static let emptyCellSubtitleForYou = "Это вы! 😝"
        static let dateFormattedString = "HH:mm"
    }
}
