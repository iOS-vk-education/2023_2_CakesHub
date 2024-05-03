//
//  NotificationView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.05.2024.
//

import SwiftUI

struct NotificationViewTest: View {
    let service = NotificationService.shared
    @State private var notifications: [FBNotification] = []
    var body: some View {
        VStack(spacing: 30) {
            ForEach(notifications, id: \.id) { notification in
                Text(notification.title)
            }

            Button("Читать") {
                Task {
                    do {
                        notifications = try await service.getNofitications()
                    } catch {
                        Logger.log(kind: .error, message: error)
                    }
                }
            }

            Button("Создать") {
                Task {
                    do {
                        try await service.createNotification(
                            notification: .init(
                                id: UUID().uuidString,
                                title: "Новое уведомление",
                                date: Date().description,
                                productID: "1E20AB69-B53D-49CF-9331-DC7AD2768F57",
                                sellerID: "6Y1qLJG5NihwnL4qsSJL5397LA93",
                                customerID: "D4zfn3CLZjb0d2PWVPIFmGhptHr2"
                            )
                        )
                    } catch {
                        Logger.log(kind: .error, message: error)
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationViewTest()
}
