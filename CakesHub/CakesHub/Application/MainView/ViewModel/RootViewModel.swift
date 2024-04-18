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
    func saveNewProduct(product: FBProductModel, completion: @escaping (Error?) -> Void)
    // MARK: Memory
    func fetchProductsFromMemory()
    func fetchProductByID(id: String) -> SDProductModel?
    func isExist(by product: FBProductModel) -> Bool
    func saveProductsInMemory()
    func addProductInMemory(product: FBProductModel)
    // MARK: Reducers
    func setCurrentUser(for user: FBUserModel)
    func addNewProduct(product: FBProductModel)
    func setContext(contex: ModelContext)
}

final class RootViewModel: ObservableObject {
    @Published private(set) var productData: ProductsData
    @Published private(set) var currentUser: FBUserModel
    @Published private(set) var isShimmering: Bool = false
    private var context: ModelContext?
    private let cakeService: CakeService

    var isAuth: Bool {
        !currentUser.uid.isEmpty && !currentUser.email.isEmpty
    }

    init(
        productsData: ProductsData = .clear,
        currentUser: FBUserModel = .clear,
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

        productData.products = try await cakeService.getCakesList()

        // Группируем данные по секциям
        DispatchQueue.global(qos: .userInteractive).async {
            self.groupDataBySection()
        }

        // Кэшируем данные
        saveProductsInMemory()
    }

    func saveNewProduct(product: FBProductModel, completion: @escaping (Error?) -> Void) {
        cakeService.createCake(cake: product, completion: completion)
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
            productData.products = products.map { $0.mapperInFBProductModel }

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
    func isExist(by product: FBProductModel) -> Bool {
        guard let oldProductFromBD = fetchProductByID(id: product.documentID) else {
            return false
        }

        // Если свойства модели изменились, продукт будет перезаписан в памяти
        let sdProduct = SDProductModel(product: product)
        return sdProduct == oldProductFromBD
    }

    /// Сохраняем торары в память устройства
    func saveProductsInMemory() {
        DispatchQueue.global(qos: .utility).async {
            self.productData.products.forEach {
                guard !self.isExist(by: $0) else {
                    Logger.log(message: "Товар с id = \($0.documentID) уже существует")
                    return
                }
                let product = SDProductModel(product: $0)
                self.context?.insert(product)
            }
            try? self.context?.save()
        }
    }
    
    /// Добавляем продукт в память устройства
    func addProductInMemory(product: FBProductModel) {
        DispatchQueue.global(qos: .utility).async {
            let sdProduct = SDProductModel(product: product)
            self.context?.insert(sdProduct)
            try? self.context?.save()
        }
    }
}

// MARK: - Reducers

extension RootViewModel {

    func setCurrentUser(for user: FBUserModel) {
        currentUser = user
        // Фильтруем данные только текущего пользователя
        productData.currentUserProducts = productData.products.filter { $0.seller.uid == currentUser.uid }
    }

    func addNewProduct(product: FBProductModel) {
        productData.products.append(product)
        productData.currentUserProducts.append(product)

        // Добавляем созданный торт в определённую секцию
        switch determineSection(for: product) {
        case .news:
            let sectionIndex = 1
            let section = productData.sections[sectionIndex]
            var oldProducts = section.products
            oldProducts.append(product.mapperToProductModel)
            productData.sections[sectionIndex] = .news(oldProducts)
        case .sales:
            let sectionIndex = 0
            let section = productData.sections[sectionIndex]
            var oldProducts = section.products
            oldProducts.append(product.mapperToProductModel)
            productData.sections[sectionIndex] = .sales(oldProducts)
        case .all:
            let sectionIndex = 2
            let section = productData.sections[sectionIndex]
            var oldProducts = section.products
            oldProducts.append(product.mapperToProductModel)
            productData.sections[sectionIndex] = .all(oldProducts)
        }

        // Отправляем запрос на сервер
        saveNewProduct(product: product) { error in
            if let error { Logger.log(kind: .error, message: error) }
        }

        // Кэшируем созданный торт в память устройства
        addProductInMemory(product: product)
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
                news.append(product.mapperToProductModel)
            case .sales:
                sales.append(product.mapperToProductModel)
            case .all:
                all.append(product.mapperToProductModel)
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
    func determineSection(for product: FBProductModel) -> Section {
        if !product.discountedPrice.isNil {
            return .sales([])
        } else if product.isNew {
            return .news([])
        }
        return .all([])
    }
}
