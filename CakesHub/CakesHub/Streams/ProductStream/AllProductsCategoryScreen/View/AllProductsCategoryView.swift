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
        MainOrEmptyView
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

    @ViewBuilder
    var MainOrEmptyView: some View {
        if viewModel.products.count == 0 {
            EmptyBlock
        } else {
            MainView
        }
    }

    var EmptyBlock: some View {
        GroupBox {
            Image(.cakeLogo)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(edge: 200)
                .foregroundStyle(Constants.emptyImageColor)
                .padding(.horizontal)

            Text(Constants.emptyText)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
        }
        .backgroundStyle(
            CHMColor<BackgroundPalette>.bgCommentView.color
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.bgColor)
    }

    var MainView: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(), count: 2),
                pinnedViews: [.sectionHeaders]
            ) {
                Section {
                    ForEach(viewModel.products) { product in
                        CHMNewProductCard(
                            configuration: product.mapperToProductCardConfiguration(height: 204),
                            didTapButton: didTapProductLike
                        )
                        .contentShape(.rect)
                        .onTapGesture {
                            didTapProductCard(product: product)
                        }
                        .padding(.bottom)
                    }
                } header: {
                    // TODO: Добавить секцию фильтров
                }
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
        static let emptyText = String(localized: "Nothing found")
        static let emptyImageColor = CHMColor<IconPalette>.iconPrimary.color
    }
}
