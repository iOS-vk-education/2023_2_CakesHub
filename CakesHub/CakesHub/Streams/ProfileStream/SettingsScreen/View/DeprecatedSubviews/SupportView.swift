//
//
//  SupportView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 19.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct SupportScreen: View {
    @State private var problemDescription = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Опишите Вашу проблему")
                    .font(.title)
                   .padding(.top, 10)
                TextField("Введите описание проблемы", text: $problemDescription)
                   .frame(height: 300)
                   .padding(.top, 10)
                   .padding()
                   .border(Color.gray, width: 0.5)
                Spacer()
                Button(action: {}) {
                    Text("Отправить")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .bold()
                }
                .frame(width: 355, height: 60)
                .background(CHMColor<BackgroundPalette>.bgRed.color)         .clipShape(RoundedRectangle(cornerRadius: 45))
                .padding(.bottom)
            }
           .padding()
        }
    }
}

struct SupportScreen_Previews: PreviewProvider {
    static var previews: some View {
        SupportScreen()
    }
}
