//
//  Settings.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 26.03.2024.
//

import SwiftUI

struct SettingssView: View {
    var body: some View {
            List {
                Section(header: Text("Персональные данные")) {
                    NavigationLink(destination: Text("Введите новый пароль")) {
                        Label("Пароль", systemImage: "lock").foregroundColor(Constants.textColor)
                    }
                    NavigationLink(destination: Text("Введите новую почту")) {
                        Label("Почта", systemImage: "envelope").foregroundColor(Constants.textColor)
                    }
                    Button(action: {}) {
                        Label("Удалить аккаунт", systemImage: "trash")
                    }
                }
                
                Section(header: Text("Уведомления")) {
                    NavigationLink(destination: NotificationsView()) {
                        Label("Уведомления", systemImage: "bell").foregroundColor(Constants.textColor)
                    }
                }
                
                Section(header: Text("Документы")) {
                    NavigationLink(destination: Text("Политика конфиденциальности")) {
                        Label("Политика конфиденциальности", systemImage: "doc.text").foregroundColor(Constants.textColor)
                    }
                    NavigationLink(destination: Text("Пользовательское соглашение")) {
                        Label("Пользовательское соглашение", systemImage: "doc.text").foregroundColor(Constants.textColor)
                    }
                }
                
                Button(action: {}) {
                    Label("Support", systemImage: "questionmark.circle")
                }
                .padding(10)
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Настройки")
            .background(Constants.bgColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingssView()
    }
}


#Preview {
    SettingssView()
}

// MARK: - Constants

private extension SettingssView {
    
    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
