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
    @StateObject var viewModel: ViewModel

    @AppStorage(ViewModel.Keys.currentPage) var currentPage = 1
    @AppStorage(ViewModel.Keys.productName) var cakeName: String = .clear
    @AppStorage(ViewModel.Keys.productDescription) var cakeDescription: String = .clear
    @AppStorage(ViewModel.Keys.productPrice) var cakePrice: String = .clear
    @AppStorage(ViewModel.Keys.productDiscountedPrice) var cakeDiscountedPrice: String = .clear
    @State var selectedPhotosData: [Data] = []

    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        MainView
            .environmentObject(viewModel)
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension CreateProductView {

    func onAppear() {
    }
}

// MARK: - Actions

extension CreateProductView {

    func didCloseProductInfoSreen() {
        viewModel.productName = cakeName
        viewModel.productDescription = cakeDescription
        withAnimation {
            currentPage += 1
        }
    }

    func didTapBackButton() {
        withAnimation {
            currentPage -= 1
        }
    }

    func didCloseProductImagesScreen() {
        viewModel.productImages = selectedPhotosData
        withAnimation {
            currentPage += 1
        }
    }
}

// MARK: - Preview

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(Navigation())
}
