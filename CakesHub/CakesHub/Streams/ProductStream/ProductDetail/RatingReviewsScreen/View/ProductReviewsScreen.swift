//
//  ProductReviewsScreen.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct ProductReviewsScreen: View, ViewModelable {

    // MARK: View Model

    typealias ViewModel = ProductReviewsViewModel
    var viewModel: ViewModel
    @EnvironmentObject var nav: Navigation
    @Binding var screenIsAppeared: Bool

    // MARK: View

    var body: some View {
        MainBlock
            .background(CHMColor<BackgroundPalette>.bgMainColor.color)
            .navigationTitle(Constants.navigationTitle)
            .toolbarTitleDisplayMode(.large)
            .onDisappear {
                screenIsAppeared = false
            }
    }
}

// MARK: - Preview

#Preview {
    ProductReviewsScreen(
        viewModel: .init(data: .mockData),
        screenIsAppeared: .constant(true)
    )
    .environmentObject(Navigation())
}

// MARK: - Constants

private extension ProductReviewsScreen {

    enum Constants {
        static let navigationTitle = "Rating&Reviews"
    }
}
