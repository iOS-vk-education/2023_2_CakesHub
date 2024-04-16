//
//  MainScreen.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct MainView: View, ViewModelable {
    typealias ViewModel = MainViewModel

    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject var rootViewModel: RootViewModel
    @StateObject var viewModel: ViewModel
    var size: CGSize

    var body: some View {
        MainBlock
            .onAppear(perform: onAppear)
            .navigationDestination(for: [ProductModel].self) { products in
                AllProductsCategoryView(viewModel: .init(products: products))
            }
    }
}

// MARK: - Network

private extension MainView {

    func onAppear() {
//        viewModel.startViewDidLoad()
//        viewModel.groupDataBySection()
    }
}

// MARK: - Actions

extension MainView {
    
    /// Нажатие на кнопку лайка карточки
    /// - Parameters:
    ///   - id: id продукта
    ///   - isSelected: флаг лайка
    func didTapFavoriteButton(id: String, section: RootViewModel.Section, isSelected: Bool) {
        Logger.log(message: "id: \(id) | section: \(section.title) | isSelected: \(isSelected)")
//        viewModel.didTapFavoriteButton(id: id, section: section, isSelected: isSelected)
    }

    /// Нажатие на карточку продукта
    /// - Parameter card: модель торта
    func didTapProductCard(card: ProductModel) {
        nav.addScreen(screen: card)
    }
    
    /// Нажатие на секцию
    /// - Parameter products: товары секции
    func didTapSection(products: [ProductModel]) {
        nav.addScreen(screen: products)
    }
    
    /// Нажатие кнопки баннера
    func didTapBannerButton() {
        Logger.log(message: "Нажатие на кнопку баннера")
    }
}

// MARK: - UI Components

private extension MainView {

    @ViewBuilder
    var MainBlock: some View {
        ScrollViewBlock
    }
}

// MARK: - Preview

#Preview {
    MainView(viewModel: .mockData, size: CGSize(width: 400, height: 800))
        .environmentObject(RootViewModel(products: .mockProducts))
        .environmentObject(Navigation())
}
