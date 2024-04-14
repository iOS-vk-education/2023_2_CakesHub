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
                TextField("Введите nickname", text: $viewModel.inputData.nickName)
                TextField("Введите email", text: $viewModel.inputData.email)
                TextField("Введите password", text: $viewModel.inputData.password)
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
        .modelContainer(for: SDUserModel.self)
}

// MARK: - Constants

private extension AuthView {

    enum Constants {
        static let textColor: Color = CHMColor<TextPalette>.textPrimary.color
    }
}
