//
//
//  EditPasswordView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 19.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct EditPasswordView: View {
    @State private var oldpassword = ""
    @State private var newpassword = ""
    
    private func validatePassword(_ password: String) -> Bool {
            let regex = "[a-zA-Z]+"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        }

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                SecureField("Старый пароль", text: $oldpassword)
                    .customStylePasswordView()
                    .onChange(of: oldpassword) { newValue in
                        if !validatePassword(newValue) {
                            Alert(title: Text("Ошибка"), message: Text("Пароль должен состоять только из латинских букв и цифр без пробелов."), dismissButton:.default(Text("ОК")))
                        }
                    }
                SecureField("Новый пароль", text: $newpassword)
                    .customStylePasswordView()
                    .onChange(of: newpassword) { newValue in
                        if !validatePassword(newValue) {
                            Alert(title: Text("Ошибка"), message: Text("Пароль должен состоять только из латинских букв и цифр без пробелов."), dismissButton:.default(Text("ОК")))
                        }
                    }
            }
            .padding(.top, 30)
            
            Button(action: {}) {
                Text("Сохранить")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .bold()
            }
            .frame(width: 320, height: 60)
            .background(CHMColor<BackgroundPalette>.bgRed.color)        .clipShape(RoundedRectangle(cornerRadius: 45))
            .padding()
         }
        .padding(110)
        Spacer()
        .navigationTitle("Настройки")
    }
}

#Preview {
    NavigationStack {
        EditPasswordView()
    }
}

struct TFStyleViewModifierPasswordView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 300)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func customStylePasswordView() -> some View {
        modifier(TFStyleViewModifier())
    }
}

//import SwiftUI
//
//struct EditPasswordView: View {
//    @State private var oldpassword = ""
//    @State private var newpassword = ""
//    
//    private func validatePassword(_ password: String) -> Bool {
//        let regex = "[a-zA-Z0-9]+" // Изменено на допустимость цифр
//        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
//    }
//
//    var body: some View {
//        VStack {
//            VStack(spacing: 16) {
//                SecureField("Старый пароль", text: $oldpassword)
//                   .customStylePasswordView()
//                   .onChange(of: oldpassword) { newValue in
//                        if!validatePassword(newValue) {
//                            Alert(title: Text("Ошибка"), message: Text("Пароль должен состоять только из латинских букв и цифр без пробелов."), dismissButton:.default(Text("ОК")))
//                        }
//                    }
//                SecureField("Новый пароль", text: $newpassword)
//                   .customStylePasswordView()
//                   .onChange(of: newpassword) { newValue in
//                        if!validatePassword(newValue) {
//                            Alert(title: Text("Ошибка"), message: Text("Пароль должен состоять только из латинских букв и цифр без пробелов."), dismissButton:.default(Text("ОК")))
//                        }
//                    }
//            }
//           .padding(.top, 30)
//            
//            Button(action: {}) {
//                Text("Сохранить")
//                   .foregroundStyle(.white)
//                   .font(.title2)
//                   .bold()
//            }
//           .frame(width: 320, height: 60)
//           .background(Color.red) // Исправлено на стандартный синий цвет, так как CHMColor не определен
//           .clipShape(RoundedRectangle(cornerRadius: 45))
//           .padding()
//         }
//      .padding(110)
//        Spacer()
//      .navigationTitle("Настройки")
//    }
//}
//
//// Обновление структуры TFStyleViewModifier и extension View для совместимости с SecureField
//struct TFStyleViewModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//          .padding()
//          .frame(width: 300)
//          .background(Color.gray.opacity(0.1)) // Исправлено на стандартный синий цвет, так как CHMColor не определен
//          .clipShape(RoundedRectangle(cornerRadius: 15))
//    }
//}
//
//extension View {
//    func customStylePasswordView() -> some View {
//        modifier(TFStyleViewModifier())
//    }
//}
