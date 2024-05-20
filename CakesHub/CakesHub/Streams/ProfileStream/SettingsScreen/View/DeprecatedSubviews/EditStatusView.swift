//
//
//  EditStatusView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 19.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct EditStatusView: View {
    @State private var createStatus = ""
    
    var body: some View {
        VStack(spacing: 40) {
            TextField("Введите статус", text: $createStatus)
                .modifier(SettingButtonsModifier(kind: .textField))

            Button(action: {}) {
                Text("Сохранить")
                    .modifier(SettingButtonsModifier(kind: .button))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .navigationTitle("Настройки")
    }
}

#Preview {
    NavigationStack {
        EditStatusView()
    }
}
