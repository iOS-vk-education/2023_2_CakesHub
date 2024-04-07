//
//  CreateProductSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

extension CreateProductView {

    var MainView: some View {
        ZStack {
            if currentPage == 1 {
                CreateCakeInfoView(
                    cakeName: $cakeName,
                    cakeDescription: $cakeDescription,
                    cakePrice: $cakePrice,
                    cakeDiscountedPrice: $cakeDiscountedPrice
                )
                .transition(.scale)
            } else if currentPage == 2 {
                AddProductImages(
                    selectedPhotosData: $selectedPhotosData,
                    backAction: didTapBackButton
                )
                .transition(.scale)
            } else if currentPage == 3 {
                ProductResultScreen(backAction: didTapBackButton)
                    .transition(.scale)
            }
        }
        .overlay(alignment: .bottom) {
            let isEnable = (
                !cakeName.isEmpty
                && !cakeDescription.isEmpty
                && !cakePrice.isEmpty
                && currentPage == 1
            ) || (
                currentPage == 2 && !selectedPhotosData.isEmpty
            ) || (
                currentPage == 3
            )
            NextButton
                .padding(.bottom)
                .disabled(!isEnable)
        }
        .background(Constants.bgColor)
    }

    var NextButton: some View {
        Button(action: {
            if currentPage == 1 {
                didCloseProductInfoSreen()
            } else if currentPage == 2 {
                didCloseProductImagesScreen()
            } else if currentPage == 3 {
                didCloseResultScreen()
            }
        }, label: {
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 60, height: 60)
                .foregroundStyle(Constants.iconColor)
                .background(.white, in: .circle)
                .overlay {
                    CircleBlock
                        .padding(-5)
                }
        })
    }

    var CircleBlock: some View {
        ZStack {
            Circle()
                .stroke(Constants.textColor.opacity(0.06), lineWidth: 4)

            Circle()
                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(viewModel.totalCount))
                .stroke(Constants.circleColor.gradient, lineWidth: 4)
                .rotationEffect(.init(degrees: -90))
        }
    }

    @ViewBuilder
    var AlertButtons: some View {
        Button("Создать", action: didTapCreateProduct)
        Button("Отмена", role: .cancel, action: didTapCancelProduct)
        Button("Удалить", role: .destructive, action: didTapDeleteProduct)
    }
}

// MARK: - Preview

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel())
}

// MARK: - Constants

private extension CreateProductView {

    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let circleColor = CHMColor<IconPalette>.iconRed.color
        static let iconColor = CHMColor<IconPalette>.iconRed.color
        static let bgColor = LinearGradient(colors: [.blue.opacity(0.6), .cyan],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
    }
}
