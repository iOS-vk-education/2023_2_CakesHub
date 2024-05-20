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
    @State private var alertMessage = ""
    @EnvironmentObject private var root: RootViewModel
    @Environment(\.dismiss) private var dismiss

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
                if showingAlert {
                    alertMessage = Constants.errorMessage
                    return
                }

                Task {
                    do {
                        try await AuthService.shared.updatePassword(
                            email: root.currentUser.email,
                            oldPassword: oldpassword,
                            newPassword: newpassword
                        )
                        dismiss()
                    } catch {
                        showingAlert = true
                        alertMessage = error.localizedDescription
                    }
                }
            }) {
                Text(String(localized: "Save"))
                    .modifier(SettingButtonsModifier(kind: .button))
                    .foregroundStyle(.white)
                    .padding(.bottom, 5)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .alert(String(localized: "Error"), isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
}

// MARK: - Constants

private extension EditPasswordView {

    enum Constants {
        static let errorMessage = String(
            localized: "The password must consist only of Latin letters and numbers without spaces."
        )
    }

    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}

// MARK: - Preview

#Preview {
    EditPasswordView()
}
