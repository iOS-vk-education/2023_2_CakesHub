//
//
//  AllChatsSubview.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

// MARK: - Cumputed Values

extension AllChatsView {

    @ViewBuilder
    var MainOrLoadingView: some View {
        if viewModel.uiProperties.showLoader {
            LoadingView
        } else {
            MainView
        }
    }

    var MainView: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    CellsBlock
                } header: {
                    SearchBarView
                        .padding(.bottom)
                }
            }
        }
        .background(Constants.bgColor)
    }

    var LoadingView: some View {
        Constants.bgColor
            .ignoresSafeArea()
            .overlay {
                ProgressView()
            }
    }

    @ViewBuilder
    var CellsBlock: some View {
        ForEach(viewModel.filterInputText) { cell in
            CellView(cell: cell)
        }
    }

    func CellView(cell: ChatCellIModel) -> some View {
        VStack {
            CHMChatCell(
                configuration: .basic(
                    imageKind: cell.user.imageKind,
                    title: cell.user.nickname,
                    subtitle: cell.lastMessage,
                    time: cell.timeMessage
                )
            )
            .padding(.horizontal)

            Divider()
        }
        .contentShape(.rect)
        .onTapGesture {
            didTapCell(with: cell)
        }
    }

    var SearchBarView: some View {
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
}

// MARK: - Preview

#Preview {
    AllChatsView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}

#Preview {
    AllChatsView()
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}

// MARK: - Constants

private extension AllChatsView {

    enum Constants {
        static let imageSize: CGFloat = 200
        static let imageCornerRadius: CGFloat = 20
        static let bgColor: Color = CHMColor<BackgroundPalette>.bgMainColor.color
        static let searchTitle = "Search"
    }
}
