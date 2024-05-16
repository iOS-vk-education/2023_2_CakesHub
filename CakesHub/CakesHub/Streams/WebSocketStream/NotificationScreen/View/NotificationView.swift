//
//  NotificationView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import SwiftData

struct NotificationView: View {

    @State var viewModel = NotificationViewModel()
    @EnvironmentObject var rootView: RootViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        MainView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: onAppear)
            .onReceive(
                NotificationCenter.default.publisher(
                    for: .WebSocketNames.notification
                )
            ) { output in
                viewModel.getNotificationsFromWebSocketLayer(output: output)
            }
    }
}

// MARK: - Actions

extension NotificationView {

    func onAppear() {
        viewModel.setModelContext(with: modelContext)
        viewModel.onAppear(currentUserID: rootView.currentUser.uid)
    }

    /// Удаление уведомления свайпом
    /// - Parameter notificationID: ID уведомления
    func didDeleteNotification(notificationID: String) {
        viewModel.deleteNotification(id: notificationID)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NotificationView()
            .environmentObject(RootViewModel.mockData)
            .modelContainer(for: [SDNotificationModel.self])
    }
}
