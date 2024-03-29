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
    @StateObject var viewModel: ViewModel
    @State private(set) var size: CGSize = .zero

    var body: some View {
        NavigationStack(path: $nav.path) {
            MainBlock
        }
        .viewSize(size: $size)
        .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension MainView {

    func onAppear() {
        viewModel.startViewDidLoad()
        viewModel.fetchData()
    }
}

// MARK: - Actions

extension MainView {
    
    /// Нажатие на кнопку лайка карточки
    /// - Parameters:
    ///   - id: id продукта
    ///   - isSelected: флаг лайка
    func didTapFavoriteButton(id: UUID, section: ViewModel.Section, isSelected: Bool) {
        Logger.log(message: "id: \(id) | section: \(section.title) | isSelected: \(isSelected)")
        viewModel.didTapFavoriteButton(id: id, section: section, isSelected: isSelected)
    }

    /// Нажатие на карточку продукта
    /// - Parameter card: модель торта
    func didTapProductCard(card: ProductModel) {
        nav.addScreen(screen: card)
    }
    
    /// Нажатие на секцию
    /// - Parameter sectionTitle: заголовок секции
    func didTapSection(sectionTitle: String) {
        Logger.log(message: sectionTitle)
    }
}

// MARK: - UI Components

private extension MainView {

    @ViewBuilder
    var MainBlock: some View {
        ScrollViewBlock
        .navigationDestination(for: ProductModel.self) { card in
            let vm = ProductDetailViewModel(data: card)
            ProductDetailScreen(viewModel: vm)
        }
    }
}

// MARK: - Preview

#Preview {
    let vm = MainView.ViewModel()
    vm.fetchPreviewData()
    return MainView(viewModel: vm)
        .environmentObject(Navigation())
}
