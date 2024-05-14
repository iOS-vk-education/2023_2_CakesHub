//
//  AuthSubviews.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 14.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

extension AuthView {

    var MainView: some View {
//        VStack {
//            Group {
//                TextField("Введите nickname", text: $viewModel.inputData.nickName)
//                TextField("Введите email", text: $viewModel.inputData.email)
//                TextField("Введите password", text: $viewModel.inputData.password)
//            }
//            .textFieldStyle(.roundedBorder)
//            .padding(.horizontal)
//
//            NextButton
//                .padding()
//        }
        AuthBlockView
    }

    var AuthBlockView: some View {
        VStack {
            Image(.cakeLogo)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundStyle(CHMColor<IconPalette>.iconPrimary.color)

            VStack{
                Text("Sign In")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Constants.textColor)
                    .kerning(1.9)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 8, content: {
                    Text("User Name")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)

                    TextField("Email", text: $viewModel.inputData.email)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Constants.textColor)
                        .padding(.top, 5)

                    Divider()
                })
                .padding(.top, 25)

                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Password")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)

                    SecureField("Password", text: $viewModel.inputData.password)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Constants.textColor)
                        .padding(.top, 5)

                    Divider()
                })
                .padding(.top, 20)

                Button(action: {}, label: {
                    Text("Forgot password?")
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)

                Button(action: {}, label: {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: Color.gray.opacity(0.6), radius: 5, x: 0, y: 0)

                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            }
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

// MARK: - Constants

private extension AuthView {

    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let deleteColor = CHMColor<TextPalette>.textWild.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
        static let iconColor = CHMColor<IconPalette>.iconPrimary.color
    }
}
