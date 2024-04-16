//
//  RootViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 29.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import SwiftData

protocol RootViewModelProtocol: AnyObject {
    func fetchData() async throws
    func fetchDataFromMemory()
}

final class RootViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published private(set) var sections: [Section] = []
    @Published var currentUser: ProductModel.SellerInfo = .clear
    @Published var currentUserProducts: [ProductModel] = []
    @Published private(set) var isShimmering: Bool = false
    private let context: ModelContext?
    private let cakeService: CakeService

    var isAuth: Bool {
        !currentUser.id.isEmpty && !currentUser.mail.isEmpty
    }

    init(
        products: [ProductModel] = [],
        currentUser: ProductModel.SellerInfo = .clear,
        currentUserProducts: [ProductModel] = [],
        cakeService: CakeService = CakeService.shared,
        context: ModelContext? = nil
    ) {
        self.products = products
        self.currentUser = currentUser
        self.currentUserProducts = currentUserProducts
        self.cakeService = cakeService
        self.context = context
        self.sections.reserveCapacity(3)
    }
}

// MARK: - Section

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

// MARK: - Network

extension RootViewModel: RootViewModelProtocol {

    @MainActor
    func fetchData() async throws {
        startViewDidLoad()
//        let cakes: [ProductRequest] = try await cakeService.getCakesList()
//        products = cakes.mapperToProductModel
        products = .mockProducts
        DispatchQueue.global(qos: .userInteractive).async {
            self.groupDataBySection()
        }

        // TODO: Кэшировать торты пользователя
//        currentUser = .king
    }

    /// Установка скелетонов
    func startViewDidLoad() {
        guard sections.isEmpty else { return }
        isShimmering = true
        let shimmeringCards: [ProductModel] = (0...7).map { .emptyCards(id: String($0)) }
        let salesSection = Section.sales(shimmeringCards)
        let newsSection = Section.news(shimmeringCards)
        let allSection = Section.all(shimmeringCards)
        sections.insert(salesSection, at: salesSection.id)
        sections.insert(newsSection, at: newsSection.id)
        sections.insert(allSection, at: allSection.id)
    }

    /// Группимровака данных по секциям
    func groupDataBySection() {
        var news: [ProductModel] = []
        var sales: [ProductModel] = []
        var all: [ProductModel] = []
        products.forEach { product in
            if !product.discountedPrice.isNil {
                sales.append(product)
                return
            } else if product.isNew {
                news.append(product)
                return
            }
            all.append(product)
        }
        // FIXME: Убрать задержку. Показана для демонстрации скелетонов
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.sections[0] = .sales(sales)
            self.sections[1] = .news(news)
            self.sections[2] = .all(all)
            self.isShimmering = false
        }
    }

    func fetchDataFromMemory() {

    }

    func saveUserProductsInMemory() {
//        let products: [SDProductModel] = currentUserProducts.map {}
    }

    func setCurrentUser(for user: ProductModel.SellerInfo) {
        currentUser = user
        currentUserProducts = self.products.filter { $0.seller.id == self.currentUser.id }
    }
}

// MARK: - Mock Data

#if DEBUG
extension RootViewModel: Mockable {

    static let mockData = RootViewModel(
        products: products,
        currentUser: currentUser,
        currentUserProducts: currentUserProducts
    )

    private static let products: [ProductModel] = .mockProducts
    private static let currentUser: ProductModel.SellerInfo = .king
    private static let currentUserProducts: [ProductModel] = products.filter { $0.seller.id == currentUser.id }
}
#endif
