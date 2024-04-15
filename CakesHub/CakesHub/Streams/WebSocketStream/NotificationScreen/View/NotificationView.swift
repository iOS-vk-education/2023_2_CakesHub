//
//  NotificationView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct NotificationView: View {

    @StateObject var viewModel = NotificationViewModel()

    var body: some View {
        MainView
            .onAppear {
                viewModel.setupWebSocket()
            }
    }
}

// MARK: - Actions

extension NotificationView {
    
    /// Удаление уведомления свайпом
    /// - Parameter notificationID: ID уведомления
    func didDeleteNotification(notificationID: Int) {
        viewModel.deleteNotification(id: notificationID)
    }
}

// MARK: - Preview

#Preview {
    NotificationView(viewModel: .mockData)
        .environmentObject(NotificationViewModel())
}
