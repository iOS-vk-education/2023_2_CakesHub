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
    
    private var isLoginButtleDisabled: Bool {
        oldusername.isEmpty || newusername.isEmpty
    }

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                TextField("Старый никнейм", text: $oldusername)
                    .customStyle()
                TextField("Новый никнейм", text: $newusername)
                    .customStyle()
            }
            .padding(.top, 30)
            
            Button(action: {}) {
                Text("Sign In")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .bold()
            }
            .frame(width: 320, height: 60)
            .background(isLoginButtleDisabled ? Color.gray.opacity(0.6) : /*CHMColor<BackgroundPalette>.bgMainColor.color*/ Color.pink.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .disabled(isLoginButtleDisabled )
            .padding()
         }
        .padding(110)
        Spacer()
        .navigationTitle("Редактирование")
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
