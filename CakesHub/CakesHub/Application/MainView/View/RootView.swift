//
//  RootView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import SwiftData

struct RootView: View {

    @StateObject private var nav = Navigation()
    @StateObject var viewModel = RootViewModel()
    @Environment(\.modelContext) private var context
    @State private var size: CGSize = .zero

    var body: some View {
        NavigationStack(path: $nav.path) {
            AuthOrMainView
        }
        .tint(CHMColor<IconPalette>.navigationBackButton.color)
        .environmentObject(nav)
        .environmentObject(viewModel)
        .viewSize(size: $size)
        .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension RootView {

    func onAppear() {
        viewModel.setContext(context: context)
        Task {
            do {
                try await viewModel.fetchData()
            } catch {
                viewModel.fetchDataWithoutNetwork()
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UI Subviews

private extension RootView {

    @ViewBuilder
    var AuthOrMainView: some View {
        if viewModel.isAuth {
            MainViewBlock
        } else {
            // FIXME: Не забыть убрать моки
            AuthView(viewModel: .mockData)
        }
    }

    var MainViewBlock: some View {
        ZStack(alignment: .bottom) {
            AllTabBarViews
            CustomTabBarView()
        }
        .navigationDestination(for: ProductModel.self) { card in
            let vm = ProductDetailViewModel(data: card)
            ProductDetailScreen(viewModel: vm)
        }
        .navigationDestination(for: UserModel.self) { user in
            let vm = ProfileViewModel(user: user)
            ProfileScreen(viewModel: vm)
        }
    }

    @ViewBuilder
    var AllTabBarViews: some View {
        switch nav.activeTab {
        case .house:
            MainView(viewModel: .init(), size: size)
        case .shop:
            CategoriesView(viewModel: .mockData)
        case .bag:
            Text("BAG")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .notifications:
            NotificationView()
        case .profile:
            ProfileScreen(
                viewModel: .init(
                    user: viewModel.currentUser.mapper.mapper(
                        products: viewModel.productData.currentUserProducts.mapperToProductModel
                    )
                )
            )
        }
    }
}

// MARK: - Preview

#Preview {
    RootView()
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
        .modelContainer(Preview(SDProductModel.self).container)
}
