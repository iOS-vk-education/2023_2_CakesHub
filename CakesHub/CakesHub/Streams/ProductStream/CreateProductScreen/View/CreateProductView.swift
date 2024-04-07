//
//  CreateProductView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct CreateProductView: View, ViewModelable {
    typealias ViewModel = CreateProductViewModel

    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject private var root: RootViewModel
    @StateObject var viewModel: ViewModel

    @AppStorage(ViewModel.Keys.currentPage) var currentPage = 1
    @AppStorage(ViewModel.Keys.productName) var cakeName: String = .clear
    @AppStorage(ViewModel.Keys.productDescription) var cakeDescription: String = .clear
    @AppStorage(ViewModel.Keys.productPrice) var cakePrice: String = .clear
    @AppStorage(ViewModel.Keys.productDiscountedPrice) var cakeDiscountedPrice: String = .clear
    @State var selectedPhotosData: [Data] = []
    @State var showAlert: Bool = false

    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        MainView
            .navigationBarBackButtonHidden(true)
            .environmentObject(viewModel)
            .onAppear(perform: onAppear)
            .alert("Создание товара", isPresented: $showAlert) {
                AlertButtons
            } message: {
                Text("Вы уверенны, что хотите создать объявление о продаже?")
            }
    }
}

// MARK: - Network

private extension CreateProductView {

    func onAppear() {}
}

// MARK: - Actions

extension CreateProductView {

    /// Нажали кнопку `далее` на экране добавления называния и описания
    func didCloseProductInfoSreen() {
        viewModel.productName = cakeName
        viewModel.productDescription = cakeDescription
        viewModel.productPrice = cakePrice
        viewModel.productDiscountedPrice = cakeDiscountedPrice
        withAnimation {
            currentPage += 1
        }
    }
    
    /// Нажали кнопку `далее` на экране добавления фотографий
    func didCloseProductImagesScreen() {
        viewModel.saveSelectedImages(imagesData: selectedPhotosData)
        withAnimation {
            currentPage += 1
        }
    }

    /// Нажали кнопку `далее` на экране просмотра результата
    func didCloseResultScreen() {
        showAlert = true
    }

    /// Нажали кнопку `назад`
    func didTapBackButton() {
        withAnimation {
            currentPage -= 1
        }
    }
    
    /// Нажали кнопку `создать`
    func didTapCreateProduct() {
        viewModel.didTapCreateProductButton()
        nav.openPreviousScreen()
    }

    /// Нажали кнопку `удалить`
    func didTapDeleteProduct() {
        viewModel.didTapDeleteProductButton()
    }

    /// Нажали кнопку `отмена`
    func didTapCancelProduct() {}
}

// MARK: - Preview

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}
