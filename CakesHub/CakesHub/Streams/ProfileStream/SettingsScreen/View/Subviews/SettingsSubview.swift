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
        .navigationTitle("Settings")
        .background(Constants.bgColor)
    }

    var PersonalSection: some View {
        Section(header: Text("Personal information")) {
            Button(action: {}) {
                Label("Password", systemImage: "lock")
                    .foregroundColor(Constants.textColor)
            }

            Button(action: {}) {
                Label("Mail", systemImage: "envelope")
                    .foregroundColor(Constants.textColor)
            }

            Button(action: {}) {
                Label("Delete account", systemImage: "trash")
                    .foregroundColor(Constants.deleteColor)
            }
        }
    }

    var NotificationSection: some View {
        Section(header: Text("Notifications")) {
            Button(action: {}) {
                Label("Notifications", systemImage: "bell")
                    .foregroundColor(Constants.textColor)
            }
        }
    }

    var DocumentsSection: some View {
        Section(header: Text("Documents")) {
            Button(action: {}) {
                Label("Privacy Policy", systemImage: "doc.text")
                    .foregroundColor(Constants.textColor)
            }

            Button(action: {}) {
                Label("User Agreement", systemImage: "doc.text")
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
