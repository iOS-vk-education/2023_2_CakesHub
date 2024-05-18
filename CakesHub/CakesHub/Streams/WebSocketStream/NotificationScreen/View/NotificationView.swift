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
    @EnvironmentObject var nav: Navigation
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        MainView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CHMColor<BackgroundPalette>.bgMainColor.color)
            .onAppear(perform: onAppear)
            .navigationDestination(for: FBNotification.self) { notification in
                let vm = NotificationDetailViewModel(
                    data: .init(notification: notification)
                )
                NotificationDetailView(viewModel: vm)
            }
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
    
    /// Нажали ячейку уведомления
    func didTapNotificationCell(notification: NotificationModel) {
        let fbNotification: FBNotification = notification.mapper
        nav.addScreen(screen: fbNotification)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NotificationView()
            .environmentObject(Navigation())
            .environmentObject(RootViewModel.mockData)
            .modelContainer(for: [SDNotificationModel.self])
    }
}
