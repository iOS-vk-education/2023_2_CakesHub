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
                BannerSectionView

                VStack(spacing: 0) {
                    ForEach(viewModel.sections, id: \.self.id) { section in
                        SectionsBlock(section: section)
                    }
                }
                .padding(.vertical, 13)
                .background(Constants.bgMainColor)
                .clipShape(.rect(cornerRadius: 16))
            }
            .padding(.bottom, 150)
        }
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .background(Constants.bgMainColor)
    }
}

// MARK: - Section

extension MainView {

    var BannerSectionView: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let iscrolling = minY > 0
            CHMBigBannerView(configuration: .mockData, didTapButton: didTapBannerButton)
            .frame(
                width: geo.size.width,
                height: iscrolling
                ? Constants.bannerPadding(size.height) + minY
                : Constants.bannerPadding(size.height)
            )
            .offset(y: -minY)
            .blur(radius: iscrolling ? 0 + minY / 60 : 0)
            .scaleEffect(iscrolling ? 1 + minY / 2000 : 1)

            Constants.bgMainColor
                .frame(height: Constants.bannerPadding(size.height))
                .offset(y: -minY)
                .opacity(-minY >= Constants.bannerPadding(size.height) ? 1 : 0)
        }
        .frame(height: max(0, Constants.bannerPadding(size.height) - 20))
    }

    @ViewBuilder
    func SectionsBlock(section: MainViewModel.Section) -> some View {
        switch section {
        case .sales(let sales):
            SectionView(
                title: section.title,
                subtitle: section.subtitle,
                buttonTitle: Constants.sectionTitle,
                cards: sales,
                badgeKind: .red
            ) { id, isSelected in
                didTapFavoriteButton(id: id, section: section, isSelected: isSelected)
            }

        case .news(let news):
            SectionView(
                title: section.title,
                subtitle: section.subtitle,
                buttonTitle: Constants.sectionTitle,
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
                buttonTitle: .clear,
                cards: all
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
            SectionHeader(
                title: title,
                subtitle: subtitle,
                buttonTitle: buttonTitle,
                cards: cards
            )
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
        buttonTitle: String,
        cards: [ProductModel]
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .style(34, .bold)

                Spacer()

                Button {
                    didTapSection(products: cards)
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
                    .frame(width: size.width * Constants.fractionWidth)
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
                configuration: .shimmering(imageHeight: size.height * Constants.fractionHeight)
            )
        } else {
            CHMNewProductCard(
                configuration: card.mapperToProductCardConfiguration(
                    height: size.height * Constants.fractionHeight,
                    badgeConfiguration: badgeConfiguration
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
        LazyVGrid(
            columns: Array(repeating:  GridItem(), count: 2),
            spacing: Constants.intrinsicHPaddings
        ) {
            ForEach(cards) { card in
                ProductCard(for: card, badgeConfiguration: .clear) { id, isSelected in
                    didTapFavoriteButton(id: id, section: .all([]), isSelected: isSelected)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    MainView(viewModel: .mockData, size: CGSize(width: 400, height: 800))
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension MainView {

    enum Constants {
        static let bgMainColor: Color = CHMColor<BackgroundPalette>.bgMainColor.color
        static let textSecondary: Color = CHMColor<TextPalette>.textSecondary.color
        static let sectionTitle = "View all"
        static let intrinsicHPaddings: CGFloat = 18
        static let fractionWidth: CGFloat = 150/375
        static let fractionHeight: CGFloat = 184/812
        static func bannerPadding(_ screenHeight: CGFloat) -> CGFloat { screenHeight * 0.65 }
    }
}
