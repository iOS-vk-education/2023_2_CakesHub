//
//  AllProductsCategoryView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 31.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct AllProductsCategoryView: View, ViewModelable {
    typealias ViewModel = AllProductsCategoryViewModel

    @EnvironmentObject private var nav: Navigation
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension AllProductsCategoryView {

    func onAppear() {
    }
}

// MARK: - Actions

private extension AllProductsCategoryView {

    func didTapProductLike(isSelected: Bool) {
    }

    func didTapProductCard(product: ProductModel) {
        nav.addScreen(screen: product)
    }
}

// MARK: - Subviews

private extension AllProductsCategoryView {

    var MainView: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(), count: 2),
                pinnedViews: [.sectionHeaders]
            ) {
                Section {
                    ForEach(viewModel.products) { product in
                        CHMNewProductCard(
                            configuration: product.mapperToProductCardConfiguration(height: 184),
                            didTapButton: didTapProductLike
                        )
                        .contentShape(.rect)
                        .onTapGesture {
                            didTapProductCard(product: product)
                        }
                        .padding(.bottom)
                    }
                } header: {}
            }
            .padding(.horizontal, 8)
        }
        .background(Constants.bgColor)
    }
}

// MARK: - Preview

#Preview {
    AllProductsCategoryView(viewModel: .mockData)
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension AllProductsCategoryView {

    enum Constants {
        static let bgColor: Color = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
