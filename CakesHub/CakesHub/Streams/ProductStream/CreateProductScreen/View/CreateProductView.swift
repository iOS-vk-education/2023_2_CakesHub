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

    @AppStorage("com.vk.currentPage.CreateProductView") var currentPage = 1

    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension CreateProductView {

    func onAppear() {
    }
}

// MARK: - Preview

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(Navigation())
}
