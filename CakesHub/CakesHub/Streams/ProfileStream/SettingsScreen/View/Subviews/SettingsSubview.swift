//
//  SettingsSubiew.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 26.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

extension SettingsView {

    var MainView: some View {
        List {
            PersonalSection

            NotificationSection

            DocumentsSection

            ButtonsBlock
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Настройки")
        .background(Constants.bgColor)
    }

    var PersonalSection: some View {
        Section(header: Text("Персональные данные")) {
            Button(action: {}) {
                Label("Пароль", systemImage: "lock")
                    .foregroundColor(Constants.textColor)
            }

            Button(action: {}) {
                Label("Почта", systemImage: "envelope")
                    .foregroundColor(Constants.textColor)
            }

            Button(action: {}) {
                Label("Удалить аккаунт", systemImage: "trash")
                    .foregroundColor(Constants.deleteColor)
            }
        }
    }

    var NotificationSection: some View {
        Section(header: Text("Уведомления")) {
            Button(action: {}) {
                Label("Уведомления", systemImage: "bell")
                    .foregroundColor(Constants.textColor)
            }
        }
    }

    var DocumentsSection: some View {
        Section(header: Text("Документы")) {
            Button(action: {}) {
                Label("Политика конфиденциальности", systemImage: "doc.text")
                    .foregroundColor(Constants.textColor)
            }

            Button(action: {}) {
                Label("Пользовательское соглашение", systemImage: "doc.text")
                    .foregroundColor(Constants.textColor)
            }
        }
    }

    @ViewBuilder
    var ButtonsBlock: some View {
        Button(action: {}) {
            Label("Support", systemImage: "questionmark.circle")
        }

        Button(action: viewModel.didTapSignOutButton, label: {
            Label("Logout", systemImage: "rectangle.portrait.and.arrow.forward")
                .foregroundStyle(Constants.deleteColor)
        })
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView(viewModel: .mockData)
    }
    .environmentObject(Navigation())
}

// MARK: - Constants

private extension SettingsView {

    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let deleteColor = CHMColor<TextPalette>.textWild.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
