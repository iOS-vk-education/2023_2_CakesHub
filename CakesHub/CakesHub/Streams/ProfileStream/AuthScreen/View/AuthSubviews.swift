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
        if !viewModel.uiProperies.isRegister {
            SignInView
                .transition(.flip)
        } else {
            RegisterView
                .transition(.reverseFlip)
        }
    }

    var SignInView: some View {
        VStack {
            LogoView

            VStack {
                TitleView(title: "Sign In")

                InputEmailBlock

                InputPasswordBlock

                AuthRegisterToggleButton(title: "Don't have account?")

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
            .foregroundStyle(CHMColor<IconPalette>.iconPrimary.color)
    }

    func TitleView(title: String) -> some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Constants.textColor)
            .kerning(1.9)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var InputEmailBlock: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text("Email")
                .fontWeight(.bold)
                .foregroundColor(.gray)

            TextField("Email", text: $viewModel.uiProperies.email)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)

            Divider()
        })
        .padding(.top, 25)
    }

    var InputPasswordBlock: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text("Password")
                .fontWeight(.bold)
                .foregroundColor(.gray)

            SecureField("Password", text: $viewModel.uiProperies.password)
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
                .foregroundStyle(Color.white)
                .padding()
                .background(Color.black)
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
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let iconColor = CHMColor<IconPalette>.iconPrimary.color
    }
}
