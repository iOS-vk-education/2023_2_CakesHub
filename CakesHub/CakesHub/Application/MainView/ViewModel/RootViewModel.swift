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
    // MARK: Network
    func fetchData() async throws
    func saveNewProduct(product: ProductModel, completion: @escaping (Error?) -> Void)
    // MARK: Memory
    func fetchProductsFromMemory()
    func fetchProductByID(id: String) -> SDProductModel?
    func isExist(by id: String) -> Bool
    func saveProductsInMemory()
    func addProductInMemory(product: ProductModel)
    // MARK: Reducers
    func setCurrentUser(for user: ProductModel.SellerInfo)
    func addNewProduct(product: ProductModel)
    func setContext(contex: ModelContext)
}

final class RootViewModel: ObservableObject {
    @Published private(set) var productData: ProductsData
    @Published private(set) var currentUser: ProductModel.SellerInfo
    @Published private(set) var isShimmering: Bool = false
    private var context: ModelContext?
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
        self.currentUser = currentUser
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

        // Кэшируем данные
        saveProductsInMemory()
    }

    func saveNewProduct(product: ProductModel, completion: @escaping (Error?) -> Void) {
        cakeService.createCake(cake: product.mapper, completion: completion)
    }
}

// MARK: - Memory CRUD

extension RootViewModel {
    
    /// Достаём данные товаров из памяти устройства
    func fetchProductsFromMemory() {
        startShimmeringAnimation()

        let fetchDescriptor = FetchDescriptor<SDProductModel>()

        do {
            guard let products = try context?.fetch(fetchDescriptor) else {
                return
            }
            productData.products = products.map { $0.mapperInProductModel }

            // Группируем данные по секциям
            DispatchQueue.global(qos: .userInteractive).async {
                self.groupDataBySection()
            }
        } catch {
            Logger.log(kind: .error, message: error)
        }
    }

    /// Достаём продукт по `id` из памяти
    func fetchProductByID(id: String) -> SDProductModel? {
        let predicate = #Predicate<SDProductModel> { $0._id == id }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        return (try? context?.fetch(fetchDescriptor))?.first
    }

    /// Проверка на наличие в памяти продукта по `id`
    func isExist(by id: String) -> Bool {
        let predicate = #Predicate<SDProductModel> { $0._id == id }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        return !((try? context?.fetch(fetchDescriptor))?.first).isNil
    }

    /// Сохраняем торары в память устройства
    func saveProductsInMemory() {
        DispatchQueue.global(qos: .utility).async {
            self.productData.products.forEach {
                guard !self.isExist(by: $0.id) else {
                    Logger.log(message: "Товар с id = \($0.id) уже существует")
                    return
                }
                let product = SDProductModel(product: $0)
                self.context?.insert(product)
            }
            try? self.context?.save()
        }
    }
    
    /// Добавляем продукт в память устройства
    func addProductInMemory(product: ProductModel) {
        DispatchQueue.global(qos: .utility).async {
            let sdProduct = SDProductModel(product: product)
            self.context?.insert(sdProduct)
            try? self.context?.save()
        }
    }
}

// MARK: - Reducers

extension RootViewModel {

    func setCurrentUser(for user: ProductModel.SellerInfo) {
        currentUser = user
        // Фильтруем данные только текущего пользователя
        productData.currentUserProducts = productData.products.filter { $0.seller.id == currentUser.id }
    }

    func addNewProduct(product: ProductModel) {
        productData.products.append(product)
        productData.currentUserProducts.append(product)

        // Добавляем созданный торт в определённую секцию
        switch determineSection(for: product) {
        case .news:
            let sectionIndex = 1
            let section = productData.sections[sectionIndex]
            var oldProducts = section.products
            oldProducts.append(product)
            productData.sections[sectionIndex] = .news(oldProducts)
        case .sales:
            let sectionIndex = 0
            let section = productData.sections[sectionIndex]
            var oldProducts = section.products
            oldProducts.append(product)
            productData.sections[sectionIndex] = .sales(oldProducts)
        case .all:
            let sectionIndex = 2
            let section = productData.sections[sectionIndex]
            var oldProducts = section.products
            oldProducts.append(product)
            productData.sections[sectionIndex] = .all(oldProducts)
        }

        // Отправляем запрос на сервер
        saveNewProduct(product: product) { error in
            if let error { Logger.log(kind: .error, message: error) }
        }

        // Кэшируем созданный торт в память устройства
//        addProductInMemory(product: product)
    }

    func setContext(contex: ModelContext) {
        guard self.context.isNil else { return }
        self.context = contex
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
            switch self.determineSection(for: product) {
            case .news:
                news.append(product)
            case .sales:
                sales.append(product)
            case .all:
                all.append(product)
            }
        }
        // FIXME: Убрать задержку. Показана для демонстрации скелетонов на РК2
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.productData.sections[0] = .sales(sales)
            self.productData.sections[1] = .news(news)
            self.productData.sections[2] = .all(all)
            self.isShimmering = false
        }
    }

    /// Определение секции товара
    func determineSection(for product: ProductModel) -> Section {
        if !product.discountedPrice.isNil {
            return .sales([])
        } else if product.isNew {
            return .news([])
        }
        return .all([])
    }
}
