//
//  ProductDetailSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.03.2024.
//

import SwiftUI

// MARK: - Subviews

extension ProductDetailScreen {

    var MainBlock: some View {
        ScrollView {
            VStack {
                ImagesBlock

                PickersBlock
                    .padding(.top, 22)

                DetailBlock

                MoreInfoBlock
                    .padding(.top, 20)

                SimilarProductsBlock
                    .padding(.top, 20)
            }
            .padding(.top, topPadding)
        }
        .makeStyle
        .overlay(alignment: .bottom) {
            BuyButton
                .padding(.bottom, UIDevice.isSe ? 16 : .zero)
        }
        .overlay(alignment: .topLeading) {
            NavigationTabBarView
        }
        .onChange(of: selectedPicker) { _, newValue in
            showSheetView = newValue != nil
        }
        .blurredSheet(
            .init(CHMColor<BackgroundPalette>.bgMainColor.color),
            show: $showSheetView
        ) {
            selectedPicker = nil
        } content: {
            SheetView
                .presentationDetents([.height(368)])
        }
    }

    var ImagesBlock: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(viewModel.currentProduct.images) { image in
                        MKRImageView(
                            configuration: .basic(
                                kind: image.kind,
                                imageSize: CGSize(width: 275, height: 413),
                                imageShape: .rectangle
                            )
                        )
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    var PickersBlock: some View {
        PickersSectionView(
            pickers: viewModel.currentProduct.pickers.map { .init(title: $0) },
            lastSelected: $selectedPicker
        )
        .overlay(alignment: .trailing) {
            LikeIcon(isSelected: $isPressedLike) {
                didTapFavoriteIcon()
            }
            .padding(.trailing)
        }
    }

    var DetailBlock: some View {
        CHMProductDescriptionView(
            configuration: .basic(
                title: viewModel.currentProduct.productName,
                price: viewModel.currentProduct.price,
                subtitle: viewModel.currentProduct.sellerName,
                description: viewModel.currentProduct.description,
                starsConfiguration: .basic(
                    kind: .init(rawValue: viewModel.currentProduct.starsCount) ?? .zero,
                    feedbackCount: viewModel.currentProduct.reviewInfo.feedbackCounter
                )
            )
        )
    }

    var SimilarProductsBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Constants.similarBlockHeaderTitle)
                .font(.system(size: 18, weight: .semibold))
                .padding(.leading, 16)

            SimilarProductCards
                .padding(.bottom, 100)
        }
    }

    var MoreInfoBlock: some View {
        VStack {
            Divider()
            // FIXME: iOS-17: Применить корректный паттерн роутинга
            Button {
                openRatingReviews()
            } label: {
                MoreInfoCell(text: ProductDetailCells.ratingReviews.rawValue)
                    .padding(.horizontal)
            }
            Divider()
            MoreInfoCell(text: ProductDetailCells.sellerInfo.rawValue)
                .padding(.horizontal)
            Divider()
        }
    }

    func MoreInfoCell(text: String) -> some View {
        HStack {
            Text(text)
                .font(.system(size: 16, weight: .regular))
                .tint(CHMColor<TextPalette>.textPrimary.color)
            Spacer()
            CHMImage.chevronRight
                .renderingMode(.template)
                .tint(CHMColor<TextPalette>.textPrimary.color)
                .frame(width: 16, height: 16)
        }
        .frame(height: 48)
    }

    var SimilarProductCards: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 11) {
                ForEach(viewModel.currentProduct.similarProducts) { product in
                    CHMNewProductCard(
                        configuration: .basic(
                            imageKind: product.images.first?.kind ?? .clear,
                            imageSize: CGSize(width: 148, height: 184),
                            productText: .init(
                                seller: product.sellerName,
                                productName: product.productName,
                                productPrice: product.price
                            ),
                            productButtonConfiguration: .basic(kind: .favorite()),
                            starsViewConfiguration: .basic(
                                kind: .init(rawValue: product.starsCount) ?? .zero,
                                feedbackCount: product.reviewInfo.feedbackCounter
                            )
                        )
                    ) { isSelected in
                        didTapLikeSimilarProductCard(id: product.id, isSelected: isSelected)
                    }
                    .onTapGesture {
                        didTapSimilarProductCard(product: product)
                    }
                }
            }
            .padding(.leading, 17)
        }
        .scrollIndicators(.hidden)
    }

    var NavigationTabBarView: some View {
        ZStack {
            Button {
                if nav.path.count >= 1 {
                    openPreviousView()
                }
            } label: {
                CHMImage.chevronLeft
                    .renderingMode(.template)
                    .tint(CHMColor<TextPalette>.textPrimary.color)
                    .padding(.leading, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Text(viewModel.currentProduct.productName)
                .font(.system(size: 18, weight: .semibold))
                .lineLimit(1)
                .tint(CHMColor<TextPalette>.textPrimary.color)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 30)
        }
        .padding(.bottom, 8)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .getSize {
            topPadding = $0.height
        }
    }

    var BuyButton: some View {
        Button {
            didTapBuyButton()
        } label: {
            Text(Constants.buyButtonTitle)
                .font(.system(size: 14, weight: .medium))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(CHMColor<BackgroundPalette>.bgRed.color)
        .clipShape(.rect(cornerRadius: 25))
        .padding(.horizontal)
        .tint(Color.white)
    }

    var SheetView: some View {
        VStack {
            if let selectedPicker {
                Text(selectedPicker.id.uuidString)
                Text(selectedPicker.title)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 3)
                .fill(CHMColor<SeparatorPalette>.divider.color)
                .frame(width: 60, height: 6)
                .padding(.top, 14)
        }
    }
}

// MARK: - Inner Subviews

fileprivate struct PickersView: View {

    struct PickerTitle: Identifiable {
        let id = UUID()
        var title: String = .clear
    }

    var pickers: [PickerTitle] = []
    @State private var lastSelected: UUID? = nil

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(pickers) { picker in
                    CHMPicker(
                        configuration: .basic(picker.title),
                        handlerConfiguration: .init(didTapView: { isSelected in
                            if isSelected {
                                lastSelected = picker.id
                            }
                        }),
                        isSelected: .constant(picker.id == lastSelected)
                    )
                }
            }
            .padding(.vertical, 1)
            .padding(.leading)
        }
    }
}

// MARK: - Extenstions

private struct ViewPreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private extension View {

    var makeStyle: some View {
        scrollIndicators(.hidden)
            .background(CHMColor<BackgroundPalette>.bgMainColor.color)
            .navigationBarBackButtonHidden()
    }

    func getSize(size: @escaping (CGSize) -> Void) -> some View {
        background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewPreferenceKey.self, value: proxy.size)
            }
        }
        .onPreferenceChange(ViewPreferenceKey.self, perform: size)
    }
}

// MARK: - Constants

private extension ProductDetailScreen {

    enum Constants {
        static let similarBlockHeaderTitle = "You can also like this"
        static let buyButtonTitle = "MAKE AN ORDER"
    }
}

// MARK: - Preview

#Preview {
    ProductDetailScreen(viewModel: .mockData)
        .environmentObject(Navigation())
}
