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

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
            .alert("Error", isPresented: $viewModel.uiProperies.showingAlert) {
                Button("OK") {}
            } message: {
                Text(viewModel.uiProperies.alertMessage ?? .clear)
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
        viewModel.didTapRegisterButton()
    }

    /// Нажатие кнопки `Войти`
    func didTapSignInButton() {
        viewModel.didTapSignInButton()
    }
}

// MARK: - Preview

#Preview {
    AuthView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
        .modelContainer(Preview(SDUserModel.self).container)
}
