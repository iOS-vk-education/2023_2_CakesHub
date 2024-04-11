//
//  Navigation.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.03.2024.
//

import SwiftUI

final class Navigation: ObservableObject {
    @Published var path = NavigationPath()
    @Published var activeTab: TabBarItem = .house
    @Published var hideTabBar: Bool = false
}

extension Navigation {

    func addScreen<T: Hashable>(screen: T) {
        path.append(screen)
    }

    func openPreviousScreen() {
        guard path.count - 1 >= 0 else { return }
        path.removeLast()
    }
}

// MARK: - TabBarItem

enum TabBarItem: String, CaseIterable {
    case house = "house"
    case shop = "cart"
    case bag = "handbag"
    case notifications = "bell.and.waves.left.and.right"
    case profile = "person"

    var title: String {
        switch self {
        case .house:
            return "Home"
        case .shop:
            return "Shop"
        case .bag:
            return "apps"
        case .notifications:
            return "notifications"
        case .profile:
            return "profile"
        }
    }
}
