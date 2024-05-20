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
        ZStack {
            MainView
                .clipShape(
                    .rect(
                        cornerRadius: showRoundedRectangle ? 26 : 0
                    )
                )
        }
        .background(CHMColor<BackgroundPalette>.bgMainColor.color.gradient)
        .ignoresSafeArea()
        .onAppear(perform: onAppear)
        .alert(String(localized: "Error"), isPresented: $viewModel.uiProperies.showingAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.uiProperies.alertMessage ?? .clear)
        }
    }

    private var showRoundedRectangle: Bool {
        UIScreen.current?.displayCornerRadius ?? 0 > 26
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

    /// Нажатие кнопки `дальше`
    func didTapNextButton() {
        if viewModel.uiProperies.isRegister {
            Logger.log(message: "Нажали кнопку регистрация")
            viewModel.didTapRegisterButton()
        } else {
            Logger.log(message: "Нажали кнопку войти")
            viewModel.didTapSignInButton()
        }
    }

    /// Нажатие кнопки `нет аккаунта`
    func didTapNoAccount() {
        withAnimation(.bouncy(duration: 2)) {
            viewModel.uiProperies.isRegister.toggle()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AuthView(viewModel: .mockData)
    }
    .environmentObject(Navigation())
    .environmentObject(RootViewModel.mockData)
    .modelContainer(Preview(SDUserModel.self).container)
}
