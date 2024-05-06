//
//  NotificationView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct NotificationView: View {

    @State var viewModel = NotificationViewModel()
    @EnvironmentObject var rootView: RootViewModel

    var body: some View {
        MainView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: onAppear)
    }
}

// MARK: - Actions

extension NotificationView {

    func onAppear() {
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
    }
}
