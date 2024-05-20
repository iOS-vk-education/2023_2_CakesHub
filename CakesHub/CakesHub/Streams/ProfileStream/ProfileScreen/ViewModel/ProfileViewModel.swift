//
//  ProfileViewModel.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 25.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

// MARK: - ProfileViewModelProtocol

protocol ProfileViewModelProtocol: AnyObject {
    // MARK: Network
    func fetchChatHistoryWithInterlocutor(interlocutorID: String) async throws -> [FBChatMessageModel]
    // MARK: Actions
    func didTapOpenChatWithInterlocutor(completion: @escaping CHMGenericBlock<[ChatMessage]>)
    // MARK: Reducers
    func setRootUser(rootUser: FBUserModel)
    func updateUserProducts(products: [ProductModel])
    func updateUserAvatar(imageKind: ImageKind)
    func updateUserHeader(imageKind: ImageKind)
    func updateUsername(name: String)
}

// MARK: - ProfileViewModelProtocol

final class ProfileViewModel: ObservableObject, ViewModelProtocol, ProfileViewModelProtocol {
    @Published private(set) var user: UserModel
    private var rootUser: FBUserModel!
    private var services: Services

    init(
        user: UserModel = .clear,
        services: Services = .clear
    ) {
        self.user = user
        self.services = services
    }
}

// MARK: - Network

extension ProfileViewModel {

    /// Получаем историю сообщений с собеседником
    func fetchChatHistoryWithInterlocutor(interlocutorID: String) async throws -> [FBChatMessageModel] {
        try await services.chatService.fetchUserHistoryMessageWithInterlocutor(userID: rootUser.uid, interlocutorID: user.id)
    }
}

// MARK: - Actions

extension ProfileViewModel {

    /// Нажали кнопку написать `сообщение`
    func didTapOpenChatWithInterlocutor(completion: @escaping CHMGenericBlock<[ChatMessage]>) {
        Task {
            do {
                let interlocutorID = user.id
                async let fbMessages = fetchChatHistoryWithInterlocutor(interlocutorID: interlocutorID)
                async let interlocutorInfo = services.userService.getUserInfo(uid: interlocutorID)

                let result = try await (interlocutorInfo, fbMessages)
                let interlocutor = result.0
                let sortedMessages = sortMessagesByDate(result.1)
                let messages: [ChatMessage] = sortedMessages.map {
                    let isYou = $0.userID == rootUser.uid
                    let messageUser: ChatMessage.UserInfo = isYou
                    ? .init(name: rootUser.nickname, image: .string(rootUser.avatarImage ?? .clear))
                    : .init(name: interlocutor.nickname, image: .string(interlocutor.avatarImage ?? .clear))
                    return ChatMessage(
                        id: $0.id,
                        isYou: isYou,
                        message: $0.message,
                        user: messageUser,
                        time: $0.dispatchDate.dateRedescription?.formattedString(format: "HH:mm") ?? .clear,
                        state: .received
                    )
                }
                await MainActor.run {
                    completion(messages)
                }
            } catch {
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
    }

    /// Сортируем сообщения по дате
    private func sortMessagesByDate(_ messages: [FBChatMessageModel]) -> [FBChatMessageModel] {
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

// MARK: - Reducers

extension ProfileViewModel {

    func setRootUser(rootUser: FBUserModel) {
        self.rootUser = rootUser
    }

    func updateUserProducts(products: [ProductModel]) {
        user.products = products
    }

    @MainActor
    func updateUserAvatar(imageKind: ImageKind) {
        user.userImage = imageKind
    }

    @MainActor
    func updateUserHeader(imageKind: ImageKind) {
        user.userHeaderImage = imageKind
    }

    @MainActor
    func updateUsername(name: String) {
        user.name = name
    }
}
