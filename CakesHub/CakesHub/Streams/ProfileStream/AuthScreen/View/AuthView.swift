//
//  AuthView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI
import SwiftData

struct AuthView: View, ViewModelable {
    typealias ViewModel = AuthViewModel

    @EnvironmentObject private var nav: Navigation
    @Environment(\.modelContext) var context
    @State var viewModel = ViewModel()

    @State private var showingAlert = false
    @State private var alertMessage: String?

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
            .alert("Ошибка", isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage ?? "")
            }
    }
}

// MARK: - Network

private extension AuthView {

    func onAppear() {
        viewModel.setContext(context: context)
        viewModel.fetchUserInfo()
    }
}

// MARK: - Actions

extension AuthView {
    
    /// Нажатие кнопки `регистрация`
    func didTapRegisterButton() {
        Task {
            do {
                try await viewModel.didTapRegisterButton()
            } catch {
                generateErrorMessage(error: error)
            }
        }
    }

    /// Нажатие кнопки `Войти`
    func didTapSignInButton() {
        Task {
            do {
                let userUID = try await viewModel.didTapSignInButton()
                Logger.log(message: userUID)
            } catch {
                generateErrorMessage(error: error)
            }
        }
    }

    private func generateErrorMessage(error: any Error) {
        showingAlert = true
        alertMessage = error.localizedDescription
        Logger.log(kind: .error, message: error)
    }
}

// MARK: - Preview

#Preview {
    AuthView(viewModel: .mockData)
        .environmentObject(Navigation())
        .modelContainer(for: [CurrentUserModel.self], isUndoEnabled: true)
}
