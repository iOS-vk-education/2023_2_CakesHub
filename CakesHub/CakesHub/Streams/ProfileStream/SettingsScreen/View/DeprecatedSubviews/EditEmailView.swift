//
//
//  EditEmailView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 19.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct EditEmailView: View {
    @State private var newEmail = ""
    @State private var showingAlert = false
    @EnvironmentObject private var root: RootViewModel

    var body: some View {
        VStack {
            Spacer()

            TextField(String(localized: "Enter your email address"), text: $newEmail)
                .modifier(SettingButtonsModifier(kind: .textField))

            Spacer()

            Button(action: {
                Task {
                    showingAlert = !isValidEmail(newEmail)
                    if showingAlert { return }
                    var oldUserInfo = root.currentUser
                    oldUserInfo.email = newEmail
                    try? await UserService.shared.updateUserInfo(with: oldUserInfo)
                }
            }) {
                Text(String(localized: "Save"))
                    .modifier(SettingButtonsModifier(kind: .button))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .alert(String(localized: "Error"), isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(String(localized: "Invalid email format."))
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EditEmailView()
    }
}
