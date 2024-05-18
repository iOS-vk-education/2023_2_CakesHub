//
//  RegistrSubviews.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 18.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct RegisterView: View {

    @State var email = ""
    @State var password = ""
    @State var repeatPassword = ""
    @State private var showAlert = false

    var body: some View {

        VStack {
            ZStack{
                Image(.cakeLogo)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundStyle(CHMColor<IconPalette>.iconPrimary.color)
            }

            VStack{
                Text("Register")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                    .kerning(1.9)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 8, content: {
                    Text("User Name")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)

                    TextField("Email", text: $email)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.black)
                        .padding(.top, 5)

                    Divider()
                })
                .padding(.top, 25)

                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Password")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)

                    SecureField("Password", text: $password)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.black)
                        .padding(.top, 5)

                    Divider()
                })
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Repeat Password")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)

                    SecureField("Password", text: $password)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.black)
                        .padding(.top, 5)

                    Divider()
                })
                .padding(.top, 20)

                Button(action: {}, label: {
                    Text("Already have an account?")
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)

                Button(action: {
                    if !isValidEmail(email) {
                        showAlert = true
                    } else if !isValidPassword(password) {
                        showAlert = true
                    }
                }, label: {
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
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Ошибка"), message: Text("Пожалуйста, введите правильный email и пароль."), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
        }
    }
}

func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
}

func isValidPassword(_ password: String) -> Bool {
    let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{6,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}

// MARK: - Preview

#Preview {
    RegisterView()
}

// MARK: - Constants

private extension RegisterView {

    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let deleteColor = CHMColor<TextPalette>.textWild.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
        static let iconColor = CHMColor<IconPalette>.iconPrimary.color
    }
}


