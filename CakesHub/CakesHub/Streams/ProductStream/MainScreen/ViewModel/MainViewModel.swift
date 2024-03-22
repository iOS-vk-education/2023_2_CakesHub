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
    func fetchData(completion: CHMVoidBlock?)
    func startViewDidLoad()
    func pullToRefresh(completion: CHMVoidBlock?)
    func didTapFavoriteButton(id: UUID, section: MainViewModel.Section, isSelected: Bool)
}

// MARK: - MainViewModel

final class MainViewModel: ObservableObject, ViewModelProtocol {

    @Published var sections: [Section] = []
    private(set) var isShimmering: Bool = false

    init() {
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
        isShimmering = true
        let shimmeringCards: [ProductModel] = (0...3).map { .emptyCards(id: $0) }
        let salesSection = Section.sales(shimmeringCards)
        let newsSection = Section.news(shimmeringCards)
        let allSection = Section.all(shimmeringCards)
        sections.insert(salesSection, at: salesSection.id)
        sections.insert(newsSection, at: newsSection.id)
        sections.insert(allSection, at: allSection.id)
    }

    func fetchData(completion: CHMVoidBlock? = nil) {
    }

    func pullToRefresh(completion: CHMVoidBlock? = nil) {
        completion?()
    }

    func didTapFavoriteButton(id: UUID, section: Section, isSelected: Bool) {
        #if DEBUG
        // TODO: Заменить на запросы в сеть. Это для превью
        switch section {
        case .news:
            guard case var .news(cakes) = sections[section.id],
                  let index = cakes.firstIndex(where: { $0.id == id })
            else { return }
            cakes[index].isFavorite = isSelected
            sections[section.id] = .news(cakes)

        case .sales:
            guard case var .sales(cakes) = sections[section.id],
                  let index = cakes.firstIndex(where: { $0.id == id })
            else { return }
            cakes[index].isFavorite = isSelected
            sections[section.id] = .sales(cakes)

        case .all:
            guard case var .all(cakes) = sections[section.id],
                  let index = cakes.firstIndex(where: { $0.id == id })
            else { return }
            cakes[index].isFavorite = isSelected
            sections[section.id] = .all(cakes)
        }
        #endif
    }
}

// MARK: - Preview

#if DEBUG
extension MainViewModel {

    func fetchPreviewData(completion: CHMVoidBlock? = nil) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.2) {
            DispatchQueue.main.async {
                self.sections[0] = .sales(.mockSalesData)
                self.sections[1] = .news(.mockNewsData)
                self.sections[2] = .all(.mockAllData)
                self.isShimmering = false
                completion?()
            }
        }
    }
}
#endif
