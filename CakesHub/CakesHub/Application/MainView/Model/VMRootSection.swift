//
//  VMRootSection.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension RootViewModel {

    enum Section {
        case news([ProductModel])
        case sales([ProductModel])
        case all([ProductModel])
    }
}

extension RootViewModel.Section {

    var itemsCount: Int {
        switch self {
        case let .news(items): return items.count
        case let .sales(items): return items.count
        case let .all(items): return items.count
        }
    }

    var products: [ProductModel] {
        switch self {
        case let .news(items): return items
        case let .sales(items): return items
        case let .all(items): return items
        }
    }

    var id: Int {
        switch self {
        case .news: return 1
        case .sales: return 0
        case .all: return 2
        }
    }

    var title: String {
        switch self {
        case .news:
            return "New"
        case .sales:
            return "Sale"
        case .all:
            return "All"
        }
    }

    var subtitle: String {
        switch self {
        case .news:
            return "You’ve never seen it before!"
        case .sales:
            return "Super summer sale"
        case .all:
            return "You can buy it right now!"
        }
    }
}
