//
//
//  EditStatusView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 19.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct EditStatusView: View {
    @State private var createStatus = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                TextField("Введите статус", text: $createStatus)
                    .customStyle_()
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
        EditStatusView()
    }
}

struct TFStyleStatusViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 300)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func customStyle_() -> some View {
        modifier(TFStyleViewModifier())
    }
}
