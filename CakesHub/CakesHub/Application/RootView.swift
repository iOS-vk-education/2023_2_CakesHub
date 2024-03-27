//
//  RootView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.03.2024.
//

import SwiftUI

struct RootView: View {

    @StateObject var nav: Navigation
    @State private var size: CGSize = .zero

    init(nav: Navigation = Navigation()) {
        self._nav = StateObject(wrappedValue: nav)
    }

    var body: some View {
        NavigationStack(path: $nav.path) {
            ZStack(alignment: .bottom) {
                MainViewBlock
                CustomTabBarView()
            }
        }
        .tint(CHMColor<IconPalette>.navigationBackButton.color)
        .environmentObject(nav)
        .viewSize(size: $size)
    }
}

private extension RootView {

    @ViewBuilder
    var MainViewBlock: some View {
        switch nav.activeTab {
        case .house:
            MainView(viewModel: MainView.ViewModel(), size: size)
        case .shop:
            CategoriesView(viewModel: .mockData)
        case .bag:
            Text("BAG")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .notifications:
            Text("NOTIFICATION")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .profile:
            ProfileScreen(viewModel: ProfileViewModel(user: .mockData))
        }
    }
}

// MARK: - Preview

#Preview {
    RootView()
        .environmentObject(Navigation())
}
