//
//  NotificationSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 31.03.2024.
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
        VStack {
            Constants.emptyImageName
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)

            Text(Constants.emptyString)
                .font(.headline)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.bgColor)
    }
}

// MARK: - Preview

#Preview {
    NotificationView(viewModel: .mockData)
        .environmentObject(NotificationViewModel())
}

#Preview {
    NotificationView()
        .environmentObject(NotificationViewModel())
}

// MARK: - Constants

private extension NotificationView {

    enum Constants {
        static let emptyImageName = Image(systemName: "envelope")
        static let emptyString = "Уведомлений нет!"
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
