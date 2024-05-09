//
//  ChatView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct ChatView: View, ViewModelable {
    typealias ViewModel = ChatViewModel

    @EnvironmentObject private var nav: Navigation
    @State var viewModel: ViewModel
    @State var messageText: String = .clear

    init(viewModel: ViewModel) {
        Logger.print("INIT ChatView: \(UIDevice.current.name)")
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
            .onReceive(
                NotificationCenter.default.publisher(
                    for: .WebSocketNames.message
                )
            ) { output in
                viewModel.receivedMessage(output: output)
            }
    }
}

// MARK: - Network

private extension ChatView {

    func onAppear() {
    }
}

// MARK: - Preview

#Preview {
    ChatView(viewModel: .mockData)
        .environmentObject(Navigation())
}
