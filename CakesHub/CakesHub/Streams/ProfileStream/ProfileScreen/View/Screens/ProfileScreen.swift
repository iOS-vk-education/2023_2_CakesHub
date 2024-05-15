//
//  ProfileScreen.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 22.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct ProfileScreen: View {
    typealias ViewModel = ProfileViewModel

    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject var rootViewModel: RootViewModel

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
            .navigationDestination(for: ViewModel.Screens.self) { screen in
                switch screen {
                case let .message(messages):
                    let interlocutor: ChatViewModel.Interlocutor = .init(
                        id: viewModel.user.id,
                        image: viewModel.user.userImage,
                        nickname: viewModel.user.name
                    )
                    // FIXME: Тут надо фетчить историю сообщений из FB
                    let vm = ChatViewModel(
                        data: .init(
                            messages: messages,
                            lastMessageID: messages.last?.id,
                            interlocutor: interlocutor,
                            user: rootViewModel.currentUser.mapper
                        )
                    )
                    ChatView(viewModel: vm)
                case .location:
                    UserLocationView()
                        .navigationBarBackButtonHidden()
                case .settings:
                    SettingsView()
                case .createProduct:
                    let vc = CreateProductViewModel(
                        rootViewModel: rootViewModel,
                        profileViewModel: viewModel
                    )
                    CreateProductView(viewModel: vc)
                }
            }
    }
}

// MARK: - Actions

extension ProfileScreen {

    func onAppear() {
        viewModel.setRootUser(rootUser: rootViewModel.currentUser)
    }

    /// Нажатие на кнопку открытия чата
    func didTapOpenMessageScreen() {
        viewModel.didTapOpenChatWithInterlocutor() { messages in
            nav.addScreen(screen: ViewModel.Screens.message(messages))
        }
    }

    /// Нажатие на кнопку создания товара
    func didTapCreateProduct() {
        nav.addScreen(screen: ViewModel.Screens.createProduct)
    }

    /// Нажатие на кнопку открытия настроек
    func didTapOpenSettings() {
        nav.addScreen(screen: ViewModel.Screens.settings)
    }

    /// Нажатие на кнопку открытия уведомлений
    func didTapOpenNotifications() {
        nav.addScreen(screen: ViewModel.Screens.location)
    }

    /// Нажали на карточку товара
    func didTapProductCard(product: ProductModel) {
        nav.addScreen(screen: product)
    }

    /// Нажали на лайк карточки товара
    func didTapProductLikeButton(for uid: String, isSelected: Bool) {
        Logger.log(message: "Нажали лайк \(uid): \(isSelected)")
    }
}

// MARK: - Preview

#Preview {
    ProfileScreen(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
        .modelContainer(Preview(SDUserModel.self).container)
}
