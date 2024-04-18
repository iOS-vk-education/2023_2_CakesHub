//
//  AuthView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import SwiftData

struct AuthView: View, ViewModelable {
    typealias ViewModel = AuthViewModel

    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject private var rootViewModel: RootViewModel
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
                Text(alertMessage ?? .clear)
            }
    }
}

// MARK: - Network

private extension AuthView {

    func onAppear() {
        viewModel.setRootViewModel(viewModel: rootViewModel)
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
                try await viewModel.didTapSignInButton()
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
        .environmentObject(RootViewModel.mockData)
        .modelContainer(Preview(SDUserModel.self).container)
}
