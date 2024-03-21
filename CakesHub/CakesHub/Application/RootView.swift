//
//  RootView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.03.2024.
//

import SwiftUI

struct RootView: View {

    @StateObject var nav: Navigation

    init(nav: Navigation = Navigation()) {
        self._nav = StateObject(wrappedValue: nav)
    }

    var body: some View {
        VStack {
            switch nav.activeTab {
            case .house:
                MainView(viewModel: MainView.ViewModel())
            case .shop:
                CategoriesView(viewModel: .mockData)
            case .bag:
                Text("BAG")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .notifications:
                Text("NOTIFICATION")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .profile:
                Text("PROFILE")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .tint(CHMColor<IconPalette>.navigationBackButton.color)
        .overlay(alignment: .bottom) {
            CustomTabBarView()
                            .offset(y: nav.hideTabBar ? 100 : 0)
        }
        .environmentObject(nav)
    }
}

// MARK: - Preview

#Preview {
    RootView()
        .environmentObject(Navigation())
}
