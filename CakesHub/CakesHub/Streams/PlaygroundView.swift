//
//  PlaygroundView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

#if DEBUG

import SwiftUI

struct PlaygroundView: View {
    var body: some View {
        VStack(spacing: 14) {
            Group {
                RegisterButton

                CreateCakeButton

                GetCakesButton
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.bgMainColor)
    }
}

// MARK: - Subviews

private extension PlaygroundView {

    var RegisterButton: some View {
        Button {
            AuthService.shared.registeUser(
                with: .mockData
            ) { result in
                switch result {
                case .success:
                    Logger.log(message: "Пользователь зареган")
                case let .failure(error):
                    Logger.log(kind: .error, message: error)
                }
            }
        } label: {
            Text("Регистрация")
                .buttonStyle
        }
    }

    var CreateCakeButton: some View {
        Button {
            CakeService.shared.createCake(cake: .mockData) { error in
                if let error {
                    Logger.log(kind: .error, message: error)
                    return
                }
                Logger.log(message: "УРА! Создал")
            }
        } label: {
            Text("Создать торт")
                .buttonStyle
        }
    }

    var GetCakesButton: some View {
        Button {
            Task {
                do {
                    let products = try await CakeService.shared.getCakesList()
                    Logger.log(message: products)
                } catch {
                    Logger.log(kind: .error, message: error)
                }
            }
        } label: {
            Text("Получить торты")
                .buttonStyle
        }
    }
}

// MARK: - Preview

#Preview {
    PlaygroundView()
}

// MARK: - View

private extension View {

    var buttonStyle: some View {
        tint(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.cyan, in: .capsule)
        .padding(.horizontal)
    }
}

#endif
