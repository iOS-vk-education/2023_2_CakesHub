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
                SecureField("Старый пароль", text: $oldpassword)
                    .modifier(SettingButtonsModifier(kind: .textField))
                    .onChange(of: oldpassword) { _, newValue in
                        showingAlert = !validatePassword(newValue)
                    }

                SecureField("Новый пароль", text: $newpassword)
                    .modifier(SettingButtonsModifier(kind: .textField))
                    .onChange(of: newpassword) { _, newValue in
                        showingAlert = !validatePassword(newValue)
                    }
            }

            Spacer()

            Button(action: {
                
            }) {
                Text("Сохранить")
                    .modifier(SettingButtonsModifier(kind: .button))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .navigationTitle("Настройки")
        .alert(String(localized: "Error"), isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Пароль должен состоять только из латинских букв и цифр без пробелов.")
        }
    }

    private func validatePassword(_ password: String) -> Bool {
        let regex = "[a-zA-Z]+"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
}

#Preview {
    NavigationStack {
        EditPasswordView()
    }
}
