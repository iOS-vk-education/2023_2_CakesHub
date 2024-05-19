//
//  EditNameView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 24.04.2024.
//

import SwiftUI

struct EditNameView: View {
    @State private var oldusername = ""
    @State private var newusername = ""
    
    private func validateUsername(_ username: String) -> Bool {
            let regex = "[a-zA-Z]+"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: username)
        }

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Text("MILANA")
                    .customStyle()
                TextField("Новый никнейм", text: $newusername)
                    .customStyle()
                    .onChange(of: newusername) { newValue in
                        if !validateUsername(newValue) {
                            Alert(title: Text("Ошибка"), message: Text("Никнейм должен состоять только из латинских букв и цифр без пробелов."), dismissButton:.default(Text("ОК")))
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
            .background(CHMColor<BackgroundPalette>.bgRed.color)         .clipShape(RoundedRectangle(cornerRadius: 45))
            .padding()
         }
        .padding(110)
        Spacer()
        .navigationTitle("Настройки")
    }
}

#Preview {
    NavigationStack {
        EditNameView()
    }
}

struct TFStyleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 300)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func customStyle() -> some View {
        modifier(TFStyleViewModifier())
    }
}
