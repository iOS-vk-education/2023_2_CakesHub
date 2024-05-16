//
//  Navigation.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
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

    func goToRoot() {
        while path.count > 0 {
            path.removeLast()
        }
        activeTab = .house
    }
}

// MARK: - TabBarItem

enum TabBarItem: String, CaseIterable {
    case house = "house"
    case categories = "cart"
    case chat = "message"
    case notifications = "bell.and.waves.left.and.right"
    case profile = "person"

    var title: String {
        switch self {
        case .house:
            return "Home"
        case .categories:
            return "Categories"
        case .chat:
            return "Chats"
        case .notifications:
            return "Notifications"
        case .profile:
            return "Profile"
        }
    }
}
