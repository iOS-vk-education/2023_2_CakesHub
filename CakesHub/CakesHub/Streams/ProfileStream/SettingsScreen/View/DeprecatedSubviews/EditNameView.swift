//
//  EditNameView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 24.04.2024.
//

import SwiftUI

struct EditNameView: View {
    @State private var newusername = ""
    @State private var showingAlert = false

    var body: some View {
        VStack {
            Spacer()

            TextField("Новый никнейм", text: $newusername)
                .modifier(SettingButtonsModifier(kind: .textField))
                .onChange(of: newusername) { _, newValue in
                    showingAlert = !validateUsername(newValue)
                }

            Spacer()

            Button(action: {}) {
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
            Text("Никнейм должен состоять только из латинских букв и цифр без пробелов.")
        }
    }

    private func validateUsername(_ username: String) -> Bool {
        let regex = "[a-zA-Z]+"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: username)
    }
}

#Preview {
    NavigationStack {
        EditNameView()
    }
}
