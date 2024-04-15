//
//  RootView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.03.2024.
//

import SwiftUI
import SwiftData

struct RootView: View {

    @StateObject private var nav = Navigation()
    @StateObject var viewModel = RootViewModel()
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
        Task {
            do {
                try await viewModel.fetchData()
            } catch {
                viewModel.fetchDataFromMemory()
                Logger.log(kind: .error, message: error)
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
            MainView(viewModel: MainView.ViewModel(rootViewModel: viewModel), size: size)
        case .shop:
            CategoriesView(viewModel: .mockData)
        case .bag:
            Text("BAG")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .notifications:
            NotificationView(viewModel: .mockData)
        case .profile:
            ProfileScreen(
                viewModel: .init(
                    user: viewModel.currentUser.mapper(products: viewModel.currentUserProducts)
                )
            )
        }
    }
}

// MARK: - Preview

#Preview {
    RootView()
        .environmentObject(Navigation())
        .modelContainer(Preview(SDUserModel.self).container)
}
