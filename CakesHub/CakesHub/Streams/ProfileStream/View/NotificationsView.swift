//
//  NotificationsView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 26.03.2024.
//

import SwiftUI

struct NotificationsView: View {

    @State var chatIsOn: Bool
    @State private var ordersIsOn: Bool
    @State private var orderStatusIsOn: Bool

    init(chatIsOn: Bool = true, ordersIsOn: Bool = true, orderStatusIsOn: Bool = true) {
        self._chatIsOn = State(wrappedValue: chatIsOn)
        self._ordersIsOn = State(wrappedValue: ordersIsOn)
        self._orderStatusIsOn = State(wrappedValue: orderStatusIsOn)
    }

    var body: some View {
        List {
            Section() {
                Group {
                    Toggle(isOn: $chatIsOn){
                        Label("Чаты", systemImage: "message")
                    }
                    .onChange(of: chatIsOn) { _, newValue in
                        Logger.log(message: newValue)
                    }

                    Toggle(isOn: $ordersIsOn){
                        Label("Заказы", systemImage: "book")
                    }
                    .onChange(of: ordersIsOn) { _, newValue in
                        Logger.log(message: newValue)
                    }

                    Toggle(isOn: $orderStatusIsOn){
                        Label("Статус заказа", systemImage: "goforward.15")
                    }
                    .onChange(of: orderStatusIsOn) { _, newValue in
                        Logger.log(message: newValue)
                    }
                }
                .foregroundStyle(Constants.textColor)
            }
        }
        .navigationTitle("Уведомления")
        .background(Constants.bgColor)
    }
}

// MARK: - Preview

#Preview {
    NotificationsView()
}

// MARK: - Constants

private extension NotificationsView {
    
    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
