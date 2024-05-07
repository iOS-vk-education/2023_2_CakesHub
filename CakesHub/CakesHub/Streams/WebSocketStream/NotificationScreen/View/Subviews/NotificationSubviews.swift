//
//  NotificationSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 31.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

// MARK: - UI Subviews

extension NotificationView {

    @ViewBuilder
    var MainView: some View {
        if viewModel.screenIsShimmering {
            ProgressScreen
        } else if viewModel.notifications.count == 0 {
            NotificationsNotFound
        } else {
            ScrollScreen
        }
    }

    var ScrollScreen: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.notifications) { notification in
                    NotificationCell(notification: notification, 
                                     deleteHandler: didDeleteNotification)
                }
            }
            .padding(.bottom, 100)
        }
    }

    var ProgressScreen: some View {
        VStack {
            ForEach(0...5, id: \.self) { _ in
                ShimmeringView()
                    .frame(maxWidth: .infinity, maxHeight: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Spacer()
        }
    }

    var NotificationsNotFound: some View {
        GroupBox {
            VStack {
                Constants.emptyImageName
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)

                Text(Constants.emptyString)
                    .font(.headline)
                    .padding(.top)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview

#Preview {
    NotificationView(viewModel: .mockData)
        .environmentObject(RootViewModel.mockData)
        .modelContainer(for: [SDNotificationModel.self])
}

#Preview {
    NotificationView()
        .environmentObject(RootViewModel.mockData)
        .modelContainer(for: [SDNotificationModel.self])
}

// MARK: - Constants

private extension NotificationView {

    enum Constants {
        static let emptyImageName = Image(systemName: "envelope")
        static let emptyString = "Уведомлений нет!"
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
