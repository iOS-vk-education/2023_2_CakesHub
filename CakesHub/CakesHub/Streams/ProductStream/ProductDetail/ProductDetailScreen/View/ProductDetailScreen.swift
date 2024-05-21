//
//  ProductDetailScreen.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct ProductDetailScreen: View {

    // MARK: View Model

    typealias ViewModel = ProductDetailViewModel
    @State var viewModel: ViewModel
    @EnvironmentObject var nav: Navigation
    @EnvironmentObject var rootViewModel: RootViewModel

    // MARK: Properties

    @State var topPadding: CGFloat = .zero
    @State var selectedPicker: PickersSectionView.PickersItem?
    @State var showSheetView = false
    @State var isPressedLike: Bool = false

    // MARK: Lifecycle

    init(viewModel: ViewModel) {
        self._viewModel = State(initialValue: viewModel)
        self._isPressedLike = State(initialValue: viewModel.currentProduct.isFavorite)
    }

    // MARK: View

    var body: some View {
        MainBlock
            .onAppear(perform: onAppear)
            .navigationDestination(for: ProductDetailCells.self) { screen in
                if screen == .ratingReviews {
                    ProductReviewsScreen(
                        viewModel: ProductReviewsViewModel(
                            data: viewModel.currentProduct.reviewInfo,
                            productID: viewModel.currentProduct.id
                        )
                    )
                }
            }
    }
}

// MARK: - Actions

extension ProductDetailScreen {

    func onAppear() {
        viewModel.setCurrentUser(user: rootViewModel.currentUser)
    }

    func didTapFavoriteIcon() {
        viewModel.currentProduct.isFavorite = false
        viewModel.didTapLikeButton(isSelected: isPressedLike) {
            isPressedLike = viewModel.currentProduct.isFavorite
        }
    }

    func didTapLikeSimilarProductCard(id: String, isSelected: Bool) {
        print("id: \(id) | isSelected: \(isSelected)")
    }

    func didTapSimilarProductCard(product: ProductModel) {
        nav.addScreen(screen: product)
    }

    /// Нажатие кнопки `оформить заказ`
    func didTapBuyButton() {
        viewModel.didTapBuyButton() {
            nav.openPreviousScreen()
        }
    }
    
    /// Нажатие кнопки `удалить товар`
    func didTapDeleteButton() {
        viewModel.didTapDeleteButton() {
            rootViewModel.deleteProduct(by: viewModel.currentProduct.id)
            nav.openPreviousScreen()
        }
    }

    func openRatingReviews() {
        nav.addScreen(screen: ProductDetailCells.ratingReviews)
    }

    func openPreviousView() {
        nav.openPreviousScreen()
    }

    func openSellerInfo() {
        let userProducts = rootViewModel.productData.products.filter {
            $0.seller.uid == viewModel.currentProduct.seller.id
        }
        let seller = viewModel.currentProduct.seller.mapper(products: userProducts.mapperToProductModel)
        nav.addScreen(screen: seller)
    }
}

// MARK: - Preview

#Preview {
    ProductDetailScreen(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}
