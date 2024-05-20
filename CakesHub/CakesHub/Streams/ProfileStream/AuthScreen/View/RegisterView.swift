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
            LogoView

            VStack {
                TitleView(title: String(localized: "Register"))

                InputNicknameBlock

                InputEmailBlock

                InputPasswordBlock

                InputRepeatPasswordBlock

                AuthRegisterToggleButton(title: String(localized: "Already have account?"))

                NextButtonView
            }
            .padding()
        }
    }

    var InputNicknameBlock: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(String(localized: "Nickname"))
                .fontWeight(.bold)
                .foregroundColor(.gray)

            TextField("Nickname", text: $viewModel.uiProperies.nickName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)

            Divider()
        })
        .padding(.top, 25)
    }

    var InputRepeatPasswordBlock: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text("Repeat Password")
                .fontWeight(.bold)
                .foregroundColor(.gray)

            SecureField("Password", text: $viewModel.uiProperies.repeatPassword)
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
