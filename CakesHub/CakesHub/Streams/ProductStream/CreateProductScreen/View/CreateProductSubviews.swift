//
//  CreateProductSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//

import SwiftUI

private let totalCount = 3

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
                OnBoardingView(
                    image: Image(uiImage: CHMImage.mockImageCake3!),
                    title: "Step 3"
                ) {
                    withAnimation(.easeInOut) { currentPage -= 1 }
                }
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
            )
            NextButton
                .padding(.bottom)
                .disabled(!isEnable)
        }
    }

    var NextButton: some View {
        Button(action: {
            if currentPage == 1 {
                didCloseProductInfoSreen()
            } else if currentPage == 2 {
                didCloseProductImagesScreen()
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
                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalCount))
                .stroke(Constants.circleColor.gradient, lineWidth: 4)
                .rotationEffect(.init(degrees: -90))
        }
    }
}

// MARK: - Preview

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension CreateProductView {

    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let circleColor = CHMColor<IconPalette>.iconRed.color
        static let iconColor = CHMColor<IconPalette>.iconRed.color
    }
}
