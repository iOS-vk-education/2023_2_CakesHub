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
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var nav: Navigation
    
    // MARK: Properties

    @State var topPadding: CGFloat = .zero
    @State var selectedPicker: PickersSectionView.PickersItem?
    @State var showSheetView = false
    @State var isPressedLike: Bool = false
    @State private var openReviewScreen = false

    // MARK: Lifecycle

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isPressedLike = State(initialValue: viewModel.currentProduct.isFavorite)
    }

    // MARK: View

    var body: some View {
        MainBlock
            .navigationDestination(for: ProductDetailCells.self) { screen in
                if screen == .ratingReviews {
                    ProductReviewsScreen(
                        viewModel: ProductReviewsViewModel(
                            data: viewModel.currentProduct.reviewInfo
                        ), 
                        screenIsAppeared: $openReviewScreen
                    )
                }
            }
            .onAppear {
                withAnimation {
                    nav.hideTabBar = true
                }
            }
            .onDisappear {
                withAnimation {
                    // Прячем таббар только при открытии экрана рейтинга
                    nav.hideTabBar = openReviewScreen
                }
            }
    }
}

// MARK: - Actions

extension ProductDetailScreen {

    func didTapFavoriteIcon() {
        viewModel.currentProduct.isFavorite = false
        viewModel.didTapLikeButton(isSelected: isPressedLike) {
            isPressedLike = viewModel.currentProduct.isFavorite
        }
    }

    func didTapLikeSimilarProductCard(id: UUID, isSelected: Bool) {
        print("id: \(id) | isSelected: \(isSelected)")
    }

    func didTapSimilarProductCard(product: ProductModel) {
        nav.addScreen(screen: product)
    }

    func didTapBuyButton() {
        viewModel.didTapBuyButton()
    }

    func openRatingReviews() {
        openReviewScreen = true
        nav.addScreen(screen: ProductDetailCells.ratingReviews)
    }

    func openPreviousView() {
        nav.openPreviousScreen()
    }
}

// MARK: - Preview

#Preview {
    ProductDetailScreen(viewModel: .mockData)
        .environmentObject(Navigation())
}
