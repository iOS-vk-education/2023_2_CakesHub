//
//  AuthSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

extension AuthView {

    var MainView: some View {
        VStack {
            Group {
                TextField("Введите nickname", text: $viewModel.uiProperies.nickName)
                TextField("Введите email", text: $viewModel.uiProperies.email)
                TextField("Введите password", text: $viewModel.uiProperies.password)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)

            NextButton
                .padding()
        }
    }

    @ViewBuilder
    var NextButton: some View {
        HStack(spacing: 30) {
            Button(action: didTapSignInButton, label: {
                Text("Войти")
            })

            Button(action: didTapRegisterButton, label: {
                Text("Регистрация")
            })
        }
    }
}

// MARK: - Preview

#Preview {
    AuthView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel())
        .modelContainer(Preview(SDUserModel.self).container)
}
