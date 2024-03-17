//
//  CategoriesView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.02.2024.
//

import SwiftUI

struct CategoriesView: View {
    typealias ViewModel = CategoriesViewModel

    @State private var selectedTab: CategoriesTab?
    @State private var tabBarProgess: CGFloat = .zero
    @State private var showSearchBar: Bool = false
    @State private var searchText: String = .clear
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = ViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            NavigationBarBlock
            CustomTabBar

            GeometryReader {
                let size = $0.size

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        FirstSection
                            .id(CategoriesTab.women)
                            .containerRelativeFrame(.horizontal)

                        SecondSection
                            .id(CategoriesTab.men)
                            .containerRelativeFrame(.horizontal)

                        CategoryContentBlock
                            .id(CategoriesTab.kids)
                            .containerRelativeFrame(.horizontal)
                    }
                    .scrollTargetLayout()
                    .offsetX { value in
                        let progress = -value / (size.width * CGFloat(CategoriesTab.allCases.count - 1))
                        tabBarProgess = max(min(progress, 1), 0)
                    }
                }
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .onAppear(perform: viewModel.fetchSections)
    }
}

// MARK: - Subviews

extension CategoriesView {

    var NavigationBarBlock: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        showSearchBar.toggle()
                    }
                } label: {
                    Image.magnifier
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

            if showSearchBar {
                SearchBar
            }
        }
    }

    var SearchBar: some View {
        HStack(spacing: 12) {
            Image.magnifier
                .renderingMode(.template)
                .foregroundStyle(CHMColor<IconPalette>.iconSecondary.color)
            TextField(Constants.searchTitle, text: $searchText)
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
                    Text(tab.rawValue)
                        .font(.system(size: 16 , weight: .regular))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
        .tabMask(tabBarProgess)
        .background {
            GeometryReader {
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(CategoriesTab.allCases.count)
                Rectangle()
                    .fill(CHMColor<BackgroundPalette>.bgBasketColor.color)
                    .frame(width: capsuleWidth, height: 3)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(x: tabBarProgess * (size.width - capsuleWidth))
            }
        }
    }

    var CategoryContentBlock: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(), count: 2)
            ) {
                ForEach(1...40, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.gradient)
                        .frame(height: 150)
                }
            }
            .padding([.horizontal, .top])
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
        }
    }

    var FirstSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.firstSections) { section in
                    CHMNewCategoryView(
                        configuration: .basic(imageKind: section.image, title: section.title)
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }

    // FIXME: Сделать по умному
    var SecondSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.secondSections) { section in
                    CHMNewCategoryView(
                        configuration: .basic(imageKind: section.image, title: section.title)
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
}

// MARK: - Preview

#Preview {
    let viewModel = CategoriesViewModel()
    return CategoriesView(viewModel: viewModel)
        .onAppear(perform: viewModel.fetchPreviewData)
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension CategoriesView {

    enum Constants {
        static let navigationTitle = "Categories"
        static let searchTitle = "Search"
    }
}
