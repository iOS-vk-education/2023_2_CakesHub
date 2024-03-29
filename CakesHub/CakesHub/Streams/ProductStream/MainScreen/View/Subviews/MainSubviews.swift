//
//  MainSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.03.2024.
//

import SwiftUI

// MARK: - Scroll View

extension MainView {

    var ScrollViewBlock: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.sections, id: \.self.id) { section in
                    SectionsBlock(section: section)
                }
            }
            .padding(.vertical, 13)
            .background(Constants.bgMainColor)
            .clipShape(.rect(cornerRadius: 16))
            .padding(.top, Constants.bannerPadding(size.height) - 15)
        }
        .scrollIndicators(.hidden)
        .background(alignment: .top) {
            CHMBigBannerView(configuration: .mockData)
                .frame(height: Constants.bannerPadding(size.height))
        }
        .background(Constants.bgMainColor)
    }
}

// MARK: - Section

extension MainView {

    @ViewBuilder
    func SectionsBlock(section: MainViewModel.Section) -> some View {
        switch section {
        case .sales(let sales):
            SectionView(
                title: section.title,
                subtitle: section.subtitle,
                buttonTitle: "View all",
                cards: sales,
                badgeKind: .red
            ) { id, isSelected in
                didTapFavoriteButton(id: id, section: section, isSelected: isSelected)
            }

        case .news(let news):
            SectionView(
                title: section.title,
                subtitle: section.subtitle,
                buttonTitle: "View all",
                cards: news,
                badgeKind: .dark
            ) { id, isSelected in
                didTapFavoriteButton(id: id, section: section, isSelected: isSelected)
            }
            .padding(.top, 40)

        case .all(let all):
            SectionHeader(
                title: section.title,
                subtitle: section.subtitle,
                buttonTitle: .clear
            )
            .padding(.horizontal, Constants.intrinsicHPaddings)
            .padding(.top, 30)

            SectinoAllCardsBlock(cards: all)
        }
    }

    func SectionView(
        title: String,
        subtitle: String,
        buttonTitle: String,
        cards: [ProductModel],
        badgeKind: CHMBadgeView.Configuration.Kind,
        complection: @escaping (UUID, Bool) -> Void
    ) -> some View {
        VStack {
            SectionHeader(title: title, subtitle: subtitle, buttonTitle: buttonTitle)
                .padding(.horizontal, Constants.intrinsicHPaddings)
            SectionCardsView(
                cards: cards,
                badgeKind: badgeKind,
                sectionTitle: title,
                complection: complection
            )
        }
    }

    func SectionHeader(
        title: String,
        subtitle: String,
        buttonTitle: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .style(34, .bold)

                Spacer()

                Button {
                    didTapSection(sectionTitle: title)
                } label: {
                    Text(buttonTitle)
                        .style(11, .regular)
                }
            }

            Text(subtitle)
                .style(11, .regular, Constants.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 22)
        .accessibilityElement(children: .combine)
    }

    func SectionCardsView(
        cards: [ProductModel],
        badgeKind: CHMBadgeView.Configuration.Kind,
        sectionTitle: String,
        complection: @escaping (UUID, Bool) -> Void
    ) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(cards) { card in
                    ProductCard(
                        for: card,
                        badgeConfiguration: .basic(text: card.badgeText, kind: badgeKind),
                        complection: complection
                    )
                }
            }
            .padding(.horizontal, Constants.intrinsicHPaddings)
        }
    }
}

// MARK: - Product Cards

extension MainView {

    @ViewBuilder
    func ProductCard(
        for card: ProductModel,
        badgeConfiguration: CHMBadgeView.Configuration,
        complection: @escaping (UUID, Bool) -> Void
    ) -> some View {
        if viewModel.isShimmering {
            CHMNewProductCard(
                configuration: .shimmering(
                    imageSize: CGSize(width: size.width * Constants.fractionWidth,
                                      height: size.height * Constants.fractionHeight)
                )
            )
        } else {
            CHMNewProductCard(
                configuration: .basic(
                    imageKind: card.images.first?.kind ?? .clear,
                    imageSize: CGSize(width: size.width * Constants.fractionWidth,
                                      height: size.height * Constants.fractionHeight),
                    productText: .init(
                        seller: card.sellerName,
                        productName: card.productName,
                        productPrice: card.price,
                        productOldPrice: card.oldPrice
                    ),
                    badgeViewConfiguration: badgeConfiguration,
                    productButtonConfiguration: .basic(
                        kind: .favorite(isSelected: card.isFavorite)
                    ),
                    starsViewConfiguration: .basic(
                        kind: .init(rawValue: card.starsCount) ?? .zero,
                        feedbackCount: card.reviewInfo.feedbackCounter
                    )
                )
            ) { isSelected in
                complection(card.id, isSelected)
            }
            .onTapGesture {
                didTapProductCard(card: card)
            }
        }
    }

    @ViewBuilder
    func SectinoAllCardsBlock(
        cards: [ProductModel]
    ) -> some View {
        let width = size.width * 0.5 - Constants.intrinsicHPaddings
        LazyVGrid(
            columns: [
                GridItem(.fixed(width)),
                GridItem(.fixed(width)),
            ],
            spacing: Constants.intrinsicHPaddings
        ) {
            ForEach(cards) { card in
                ProductCard(for: card, badgeConfiguration: .clear) { id, isSelected in
                    didTapFavoriteButton(id: id, section: .all([]), isSelected: isSelected)
                }
            }
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

// MARK: - Constants

private extension MainView {

    enum Constants {
        static let bgMainColor: Color = CHMColor<BackgroundPalette>.bgMainColor.color
        static let textSecondary: Color = CHMColor<TextPalette>.textSecondary.color
        static let intrinsicHPaddings: CGFloat = 18
        static let fractionWidth: CGFloat = 150/375
        static let fractionHeight: CGFloat = 184/812
        static func bannerPadding(_ screenHeight: CGFloat) -> CGFloat { screenHeight * 0.65 }
    }
}
