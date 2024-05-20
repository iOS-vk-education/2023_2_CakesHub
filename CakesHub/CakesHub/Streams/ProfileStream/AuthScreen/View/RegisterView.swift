//
//  RegisterView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 18.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

extension AuthView {

    var RegisterView: some View {
        VStack {
            if !UIDevice.isSe {
                LogoView
            }

            VStack {
                TitleView(title: Constants.registerTitle)

                InputNicknameBlock

                InputEmailBlock

                InputPasswordBlock

                InputRepeatPasswordBlock

                AuthRegisterToggleButton(title: Constants.haveAccountTitle)

                NextButtonView
            }
            .padding()
        }
    }

    var InputNicknameBlock: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(Constants.nicknameTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            TextField(Constants.nicknameTitle, text: $viewModel.uiProperies.nickName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)

            Divider()
        })
        .padding(.top, 25)
    }

    var InputRepeatPasswordBlock: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(Constants.repeatPasswordTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            SecureField(Constants.passwordTitle, text: $viewModel.uiProperies.repeatPassword)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)

            Divider()
        })
        .padding(.top, 20)
    }
}

// MARK: - Preview

#Preview {
    AuthView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel())
        .modelContainer(Preview(SDUserModel.self).container)
}
