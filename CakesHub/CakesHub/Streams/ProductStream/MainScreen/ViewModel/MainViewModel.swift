//
//  MainViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

// MARK: - MainViewModelProtocol

protocol MainViewModelProtocol: AnyObject {
    func groupDataBySection()
    func startViewDidLoad()
    func pullToRefresh()
    func didTapFavoriteButton(id: String, section: MainViewModel.Section, isSelected: Bool)
}

// MARK: - MainViewModel

final class MainViewModel: ObservableObject, ViewModelProtocol {

    @Published private(set) var sections: [Section] = []
    private(set) var rootViewModel: RootViewModel
    private(set) var isShimmering: Bool = false

    init(rootViewModel: RootViewModel) {
        self.rootViewModel = rootViewModel
        self.sections.reserveCapacity(3)
    }
}

// MARK: - Section

extension MainViewModel {

    enum Section {
        case news([ProductModel])
        case sales([ProductModel])
        case all([ProductModel])
    }
}

extension MainViewModel.Section {

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

// MARK: - Actions

extension MainViewModel: MainViewModelProtocol {

    func startViewDidLoad() {
        guard sections.isEmpty else { return }
        isShimmering = true
        let shimmeringCards: [ProductModel] = (0...3).map { .emptyCards(id: String($0)) }
        let salesSection = Section.sales(shimmeringCards)
        let newsSection = Section.news(shimmeringCards)
        let allSection = Section.all(shimmeringCards)
        sections.insert(salesSection, at: salesSection.id)
        sections.insert(newsSection, at: newsSection.id)
        sections.insert(allSection, at: allSection.id)
    }

    func groupDataBySection() {
        var news: [ProductModel] = []
        var sales: [ProductModel] = []
        var all: [ProductModel] = []
        rootViewModel.products.forEach { product in
            if !product.discountedPrice.isNil {
                sales.append(product)
                return
            } else if product.isNew {
                news.append(product)
                return
            }
            all.append(product)
        }
        sections[0] = .sales(sales)
        sections[1] = .news(news)
        sections[2] = .all(all)
        isShimmering = false
    }

    func pullToRefresh() {}

    func didTapFavoriteButton(id: String, section: Section, isSelected: Bool) {}
}
