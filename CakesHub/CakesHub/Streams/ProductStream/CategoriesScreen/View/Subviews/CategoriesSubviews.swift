//
//  CategoriesSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

// MARK: - Subviews

extension CategoriesView {

    var MainViewBlock: some View {
        VStack(spacing: 0) {
            NavigationBarBlock

            CustomTabBar

            SectionsBlock
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
    }

    var NavigationBarBlock: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        viewModel.uiProperties.showSearchBar.toggle()
                    }
                } label: {
                    CHMImage.magnifier
                        .renderingMode(.template)
                }
            }
            .font(.title2)
            .overlay {
                Text(Constants.navigationTitle)
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)

            if viewModel.uiProperties.showSearchBar {
                SearchBar
            }
        }
    }

    var SearchBar: some View {
        HStack(spacing: 12) {
            CHMImage.magnifier
                .renderingMode(.template)
                .foregroundStyle(CHMColor<IconPalette>.iconSecondary.color)
            TextField(Constants.searchTitle, text: $viewModel.uiProperties.searchText)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 15)
        .background(CHMColor<BackgroundPalette>.bgSearchBar.color, in: .capsule)
        .padding(.horizontal)
    }

    var CustomTabBar: some View {
        HStack(spacing: 0) {
            ForEach(CategoriesTab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Text(tab.title)
                        .font(.system(size: 16 , weight: .regular))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .onTapGesture {
                    withAnimation(.snappy) {
                        viewModel.uiProperties.selectedTab = tab
                    }
                }
            }
        }
        .tabMask(viewModel.uiProperties.tabBarProgess)
        .background {
            GeometryReader {
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(CategoriesTab.allCases.count)
                Rectangle()
                    .fill(CHMColor<BackgroundPalette>.bgBasketColor.color)
                    .frame(width: capsuleWidth, height: 3)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(
                        x: viewModel.uiProperties.tabBarProgess * (size.width - capsuleWidth)
                    )
            }
        }
    }

    var SectionsBlock: some View {
        GeometryReader {
            let size = $0.size

            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.sections) { section in
                        switch section {
                        case let .men(categories):
                            ScrollSections(
                                items: viewModel.filterData(categories: categories)
                            )
                            .id(CategoriesTab.men)
                            .containerRelativeFrame(.horizontal)
                        case let .women(categories):
                            ScrollSections(
                                items: viewModel.filterData(categories: categories)
                            )
                            .id(CategoriesTab.women)
                            .containerRelativeFrame(.horizontal)
                        case let .kids(categories):
                            ScrollSections(
                                items: viewModel.filterData(categories: categories)
                            )
                            .id(CategoriesTab.kids)
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                }
                .scrollTargetLayout()
                .offsetX { value in
                    let progress = -value / (size.width * CGFloat(CategoriesTab.allCases.count - 1))
                    viewModel.uiProperties.tabBarProgess = max(min(progress, 1), 0)
                }
            }
            .scrollPosition(id: $viewModel.uiProperties.selectedTab)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollClipDisabled()
        }
    }

    func ScrollSections(items: [CategoryCardModel]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(items) { section in
                    CHMNewCategoryView(
                        configuration: .basic(imageKind: section.image, title: section.title)
                    )
                    .padding(.horizontal)
                    .contentShape(.rect)
                    .onTapGesture {
                        didTapSectionCell(title: section.title)
                    }
                }
            }
            .padding(.top)
        }
    }
}

// MARK: - Helpers

private extension CategoriesView {

    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader {
                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX

                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: completion)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CategoriesView(viewModel: .mockData)
        .environmentObject(RootViewModel.mockData)
}

// MARK: - Constants

private extension CategoriesView {

    enum Constants {
        static let navigationTitle = String(localized: "Categories")
        static let searchTitle = String(localized: "Search")
    }
}
