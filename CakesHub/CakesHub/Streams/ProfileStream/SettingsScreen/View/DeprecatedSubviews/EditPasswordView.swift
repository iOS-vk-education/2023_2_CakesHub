//
//
//  EditPasswordView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 19.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct EditPasswordView: View {
    @State private var oldpassword = ""
    @State private var newpassword = ""
    @State private var showingAlert = false

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                SecureField(String(localized: "Old password"), text: $oldpassword)
                    .modifier(SettingButtonsModifier(kind: .textField))

                SecureField(String(localized: "New password"), text: $newpassword)
                    .modifier(SettingButtonsModifier(kind: .textField))
            }

            Spacer()

            Button(action: {
                showingAlert = !validatePassword(oldpassword) || !validatePassword(newpassword)
                if showingAlert { return }
                // TODO: Добавить смену пароля
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
            Text(String(localized: "The password must consist only of Latin letters and numbers without spaces."))
        }
    }

    private func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}

// MARK: - Preview

#Preview {
    EditPasswordView()
}
