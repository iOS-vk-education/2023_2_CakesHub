//
//  AllChatsView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct AllChatsView: View, ViewModelable {
    typealias ViewModel = AllChatsViewModel

    @State var viewModel = ViewModel()
    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject private var root: RootViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        MainOrLoadingView
            .onAppear(perform: onAppear)
            .onReceive(
                NotificationCenter.default.publisher(for: .WebSocketNames.message)
            ) { output in
                viewModel.receiveMessage(output: output)
            }
            .navigationDestination(for: ViewModel.Screens.self) { screen in
                switch screen {
                case let .chat(messages, interlocutor):
                    let lastMessageID = messages.last?.id
                    let vm = ChatViewModel(
                        messages: messages,
                        lastMessageID: lastMessageID,
                        interlocutor: interlocutor,
                        user: root.currentUser.mapper
                    )
                    ChatView(viewModel: vm)
                }
            }
    }
}

// MARK: - Network

private extension AllChatsView {

    func onAppear() {
        viewModel.setReducers(modelContext: modelContext, root: root, nav: nav)
        viewModel.onAppear()
    }
}

// MARK: - Action

extension AllChatsView {

    func didTapCell(with cellInfo: ChatCellModel) {
        viewModel.didTapCell(with: cellInfo)
    }
}

// MARK: - Preview

#Preview {
    AllChatsView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}
