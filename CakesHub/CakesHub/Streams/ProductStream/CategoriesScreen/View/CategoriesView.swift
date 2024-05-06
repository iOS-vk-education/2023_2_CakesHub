//
//  CategoriesView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.02.2024.
//

import SwiftUI

struct CategoriesView: View {
    
    // MARK: View Model

    typealias ViewModel = CategoriesViewModel
    @State private(set) var viewModel = ViewModel()
    @EnvironmentObject private var root: RootViewModel
    @EnvironmentObject private var nav: Navigation

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
}
