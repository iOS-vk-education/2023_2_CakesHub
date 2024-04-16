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
    // Network
    func fetchData() async throws
    // Memory
    func fetchProductsFromMemory()
    func saveUserProductsInMemory()
    // Reducers
    func setCurrentUser(for user: ProductModel.SellerInfo)
    func addNewProduct(product: ProductModel)
}

final class RootViewModel: ObservableObject {
    @Published private(set) var productData: ProductsData
    @Published private(set) var currentUser: ProductModel.SellerInfo = .clear
    @Published private(set) var isShimmering: Bool = false
    private let context: ModelContext?
    private let cakeService: CakeService

    var isAuth: Bool {
        !currentUser.id.isEmpty && !currentUser.mail.isEmpty
    }

    init(
        productsData: ProductsData = .clear,
        currentUser: ProductModel.SellerInfo = .clear,
        cakeService: CakeService = CakeService.shared,
        context: ModelContext? = nil
    ) {
        self.productData = productsData
        self.cakeService = cakeService
        self.context = context
        productData.sections.reserveCapacity(3)
    }
}

// MARK: - Network

extension RootViewModel: RootViewModelProtocol {

    @MainActor
    func fetchData() async throws {
        // Запуск шиммеров
        startShimmeringAnimation()

//        let cakes: [ProductRequest] = try await cakeService.getCakesList()
//        products = cakes.mapperToProductModel
        productData.products = .mockProducts

        // Группируем данные по секциям
        DispatchQueue.global(qos: .userInteractive).async {
            self.groupDataBySection()
        }
    }
}

// MARK: - Memory CRUD

extension RootViewModel {

    func fetchProductsFromMemory() {}

    func saveUserProductsInMemory() {
//        let products: [SDProductModel] = currentUserProducts.map {}
    }
}

// MARK: - Reducers

extension RootViewModel {

    func setCurrentUser(for user: ProductModel.SellerInfo) {
        currentUser = user
        // Фильтруем данные только текущего пользователя
        productData.currentUserProducts = productData.products.filter { $0.seller.id == currentUser.id }
        // Кэшируем данные пользователя
        saveUserProductsInMemory()
    }

    func addNewProduct(product: ProductModel) {
        // FIXME: Тут надо додумать, куда ещё это сетить
        productData.products.append(product)
        productData.currentUserProducts.append(product)
    }
}

// MARK: - Inner Methods

private extension RootViewModel {

    /// Начинаем анимацию карточек категорий
    func startShimmeringAnimation() {
        guard productData.sections.isEmpty else { return }
        isShimmering = true
        let shimmeringCards: [ProductModel] = (0...7).map { .emptyCards(id: String($0)) }
        let salesSection = Section.sales(shimmeringCards)
        let newsSection = Section.news(shimmeringCards)
        let allSection = Section.all(shimmeringCards)
        productData.sections.insert(salesSection, at: salesSection.id)
        productData.sections.insert(newsSection, at: newsSection.id)
        productData.sections.insert(allSection, at: allSection.id)
    }

    /// Группимровака данных по секциям
    func groupDataBySection() {
        var news: [ProductModel] = []
        var sales: [ProductModel] = []
        var all: [ProductModel] = []
        productData.products.forEach { product in
            if !product.discountedPrice.isNil {
                sales.append(product)
                return
            } else if product.isNew {
                news.append(product)
                return
            }
            all.append(product)
        }
        // FIXME: Убрать задержку. Показана для демонстрации скелетонов на РК2
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.productData.sections[0] = .sales(sales)
            self.productData.sections[1] = .news(news)
            self.productData.sections[2] = .all(all)
            self.isShimmering = false
        }
    }
}
