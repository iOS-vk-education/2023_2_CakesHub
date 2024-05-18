//
//  AuthSubviews.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 14.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

extension AuthView {

    @ViewBuilder
    var MainView: some View {
        Group {
            if !viewModel.uiProperies.isRegister {
                SignInView
                    .transition(.flip)
            } else {
                RegisterView
                    .transition(.reverseFlip)
            }
        }
        .frame(maxHeight: .infinity)
        .background(Constants.bgColor)
    }

    var SignInView: some View {
        VStack {
            LogoView

            VStack {
                TitleView(title: Constants.signInTitle)

                InputEmailBlock

                InputPasswordBlock

                AuthRegisterToggleButton(title: Constants.dontHaveAccountTitle)

                NextButtonView
            }
            .padding()
        }
    }

    var LogoView: some View {
        Image(.cakeLogo)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
            .foregroundStyle(Constants.iconColor)
    }

    func TitleView(title: String) -> some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Constants.titleColor)
            .kerning(1.9)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var InputEmailBlock: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(Constants.emailTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            TextField(Constants.emailTitle, text: $viewModel.uiProperies.email)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)

            Divider()
        })
        .padding(.top, 25)
    }

    var InputPasswordBlock: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(Constants.passwordTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            SecureField(Constants.passwordTitle, text: $viewModel.uiProperies.password)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)

            Divider()
        })
        .padding(.top, 20)
    }

    func AuthRegisterToggleButton(title: String) -> some View {
        Button(action: didTapNoAccount, label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
        })
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 10)
    }

    var NextButtonView: some View {
        Button(action: didTapNextButton, label: {
            Image(systemName: "arrow.right")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Constants.iconColor)
                .padding()
                .background(Constants.bgColor)
                .clipShape(Circle())
                .shadow(color: Color.gray.opacity(0.6), radius: 5, x: 0, y: 0)

        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
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

extension AuthView {

    enum Constants {
        static let titleColor = CHMColor<TextPalette>.textRed.color
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let iconColor = CHMColor<IconPalette>.iconRed.color.gradient
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
        static let nicknameTitle = String(localized: "Nickname")
        static let passwordTitle = String(localized: "Password")
        static let repeatPasswordTitle = String(localized: "Repeat Password")
        static let emailTitle = String(localized: "Email")
        static let signInTitle = String(localized: "Sign In")
        static let registerTitle = String(localized: "Register")
        static let dontHaveAccountTitle = String(localized: "Don't have account?")
        static let haveAccountTitle = String(localized: "Already have account?")
    }
}
