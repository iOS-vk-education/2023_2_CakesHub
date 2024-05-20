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
    @State private var alertMessage = ""
    @EnvironmentObject private var root: RootViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Spacer()

            TextField(String(localized: "Enter your email address"), text: $newEmail)
                .modifier(SettingButtonsModifier(kind: .textField))

            Spacer()

            Button(action: {
                Task {
                    showingAlert = !isValidEmail(newEmail)
                    if showingAlert {
                        showingAlert = true
                        alertMessage = Constants.errorMessage
                        return
                    }
                    var oldUserInfo = root.currentUser
                    oldUserInfo.email = newEmail
                    do {
                        try await UserService.shared.updateUserInfo(with: oldUserInfo)
                        dismiss()
                    } catch {
                        alertMessage = error.localizedDescription
                        showingAlert = true
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

private extension EditEmailView {

    enum Constants {
        static let errorMessage = String(localized: "Invalid email format.")
    }

    func isValidEmail(_ email: String) -> Bool {
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
