//
//  CategoriesView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    
    // MARK: View Model

    typealias ViewModel = CategoriesViewModel
    @State private(set) var viewModel = ViewModel()
    @EnvironmentObject private var root: RootViewModel
    @EnvironmentObject private var nav: Navigation
    @Environment(\.modelContext) private var modelContext

    // MARK: View

    var body: some View {
        MainViewBlock
            .onAppear(perform: onAppear)
            .navigationDestination(for: ViewModel.Screens.self) { screen in
                switch screen {
                case let .sectionCakes(products):
                    let productModels: [ProductModel] = products.mapperToProductModel
                    let vm = AllProductsCategoryViewModel(products: productModels)
                    AllProductsCategoryView(viewModel: vm)
                }
            }
    }
}

// MARK: - Network

private extension CategoriesView {

    func onAppear() {
        viewModel.setRootViewModel(with: root)
        viewModel.setModelContext(with: modelContext)
        viewModel.fetchSections()
    }
}

// MARK: - Actions

extension CategoriesView {

    /// Нажали на ячейку секции
    func didTapSectionCell(title: String) {
        let products = viewModel.didTapSectionCell(title: title)
        nav.addScreen(screen: ViewModel.Screens.sectionCakes(products))
    }
}

// MARK: - Preview

#Preview {
    CategoriesView()
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
        .modelContainer(
            Preview(SDCateoryModel.self).container
        )
}
