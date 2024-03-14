//
//  MainScreen.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 15.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct MainView: View, ViewModelable {
    typealias ViewModel = MainViewModel

    @EnvironmentObject private var nav: Navigation
    @StateObject var viewModel: ViewModel
    @State private var size: CGSize = .zero

    var body: some View {
        MainView
            .viewSize(size: $size)
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension MainView {

    func onAppear() {
        viewModel.startViewDidLoad()
        viewModel.fetchData()
    }
}

// MARK: - Subviews

private extension MainView {

    var MainView: some View {
        NavigationStack(path: $nav.path) {
            ScrollView {
                VStack {
                    ForEach(viewModel.sections, id: \.self.id) { section in
                        switch section {
                        case .sales(let sales):
                            SectionView(
                                title: "Sale",
                                subtitle: "Super summer sale",
                                buttonTitle: "View all",
                                cards: sales,
                                badgeKind: .red
                            )
                        case .news(let news):
                            SectionView(
                                title: "New",
                                subtitle: "You’ve never seen it before!",
                                buttonTitle: "View all",
                                cards: news,
                                badgeKind: .dark
                            )
                            .padding(.top, 40)
                        case .all(let all):
                            SectionHeader(
                                title: "All",
                                subtitle: "You can buy it right now!",
                                buttonTitle: ""
                            )
                            .padding(.horizontal, .intrinsicHPaddings)
                            .padding(.top, 30)
                            SectinoAllCardsBlock(cards: all)
                        }
                    }
                }
                .padding(.vertical, 13)
                .background(Color.bgMainColor)
                .clipShape(.rect(cornerRadius: 16))
                .padding(.top, .bannerPadding(size.height) - 15)
            }
            .scrollIndicators(.hidden)
            .background(alignment: .top) {
                CHMBigBannerView(configuration: .mockData)
                    .frame(height: .bannerPadding(size.height))
            }
            .background(Color.bgMainColor)
            .navigationDestination(for: ProductModel.self) { card in
                let vm = ProductDetailViewModel(data: card)
                ProductDetailScreen(viewModel: vm)
            }
            .onAppear {
                withAnimation {
                    nav.hideTabBar = false
                }
            }
        }
    }

    func SectionView(
        title: String,
        subtitle: String,
        buttonTitle: String,
        cards: [ProductModel],
        badgeKind: CHMBadgeView.Configuration.Kind
    ) -> some View {
        VStack {
            SectionHeader(title: title, subtitle: subtitle, buttonTitle: buttonTitle)
                .padding(.horizontal, .intrinsicHPaddings)
            SectionCardsView(cards: cards, badgeKind: badgeKind)
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
                    // TODO: Нажатие на секцию
                } label: {
                    Text(buttonTitle)
                        .style(11, .regular)
                }
            }

            Text(subtitle)
                .style(11, .regular, .textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 22)
    }

    func SectionCardsView(
        cards: [ProductModel],
        badgeKind: CHMBadgeView.Configuration.Kind
    ) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(cards) { card in
                    ProductCard(
                        for: card,
                        badgeConfiguration: .basic(text: card.badgeText, kind: badgeKind)
                    )
                }
            }
            .padding(.horizontal, .intrinsicHPaddings)
        }
    }

    @ViewBuilder
    func ProductCard(
        for card: ProductModel,
        badgeConfiguration: CHMBadgeView.Configuration
    ) -> some View {
        if viewModel.isShimmering {
            CHMNewProductCard(
                configuration: .shimmering(
                    imageSize: CGSize(width: size.width * .fractionWidth,
                                      height: size.height * .fractionHeight)
                )
            )
        } else {
            CHMNewProductCard(
                configuration: .basic(
                    imageKind: card.images.first?.kind ?? .clear,
                    imageSize: CGSize(width: size.width * .fractionWidth,
                                      height: size.height * .fractionHeight),
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
            )
            .onTapGesture {
                withAnimation {
                    nav.hideTabBar = true
                }
                nav.addScreen(screen: card)
            }
        }
    }

    @ViewBuilder
    func SectinoAllCardsBlock(
        cards: [ProductModel]
    ) -> some View {
        let width = size.width * 0.5 - .intrinsicHPaddings
        LazyVGrid(
            columns: [
                GridItem(.fixed(width)),
                GridItem(.fixed(width)),
            ],
            spacing: .intrinsicHPaddings
        ) {
            ForEach(cards) { card in
                ProductCard(for: card, badgeConfiguration: .clear)
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

private extension CGFloat {

    static func bannerPadding(_ screenHeight: CGFloat) -> CGFloat { screenHeight * 0.65 }
    static var intrinsicHPaddings: CGFloat = 18
    static var fractionWidth: CGFloat = 150/375
    static var fractionHeight: CGFloat = 184/812
}
