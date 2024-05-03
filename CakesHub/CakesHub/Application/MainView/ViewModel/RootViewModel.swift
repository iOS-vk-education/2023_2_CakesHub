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
    func fetchProductsFromMemory() -> [SDProductModel]
    func fetchProductByID(id: String) -> SDProductModel?
    func saveProductsInMemory(products: [FBProductModel])
    func addProductInMemory(product: FBProductModel)
    // MARK: Reducers
    func setCurrentUser(for user: FBUserModel)
    func addNewProduct(product: FBProductModel)
    func setContext(context: ModelContext)
}

// MARK: - RootViewModel

final class RootViewModel: ObservableObject {
    @Published private(set) var productData: ProductsData
    @Published private(set) var currentUser: FBUserModel
    @Published private(set) var isShimmering: Bool = false
    private var context: ModelContext?
    private var services: Services

    var isAuth: Bool {
        !currentUser.uid.isEmpty && !currentUser.email.isEmpty
    }

    init(
        productsData: ProductsData = .clear,
        currentUser: FBUserModel = .clear,
        services: Services = .clear
    ) {
        self.productData = productsData
        self.services = services
        self.currentUser = currentUser
        productData.sections.reserveCapacity(3)
    }
}

// MARK: - Network

extension RootViewModel: RootViewModelProtocol {

    @MainActor
    func fetchData() async throws {
        // Запуск шиммеров
        startShimmeringAnimation()

        // Достаём закэшированные данные
        let sdProducts = fetchProductsFromMemory()
        let fbProducts = sdProducts.map { $0.mapperInFBProductModel }
        productData.products = fbProducts
        filterCurrentUserProducts()
        groupDataBySection(data: fbProducts) { [weak self] sections in
            guard let self else { return }
            productData.sections = sections
            isShimmering = sections.isEmpty
        }

        // Достаём данные из сети
        let newFBProducts = try await services.cakeService.getCakesList()
        productData.products = newFBProducts
        filterCurrentUserProducts()

        // Кэшируем данные
        saveProductsInMemory(products: newFBProducts)

        // Группируем данные по секциям
        groupDataBySection(data: newFBProducts) { [weak self] sections in
            guard let self else { return }
            productData.sections = sections
            isShimmering = false
        }
    }

    func saveNewProduct(product: FBProductModel, completion: @escaping (Error?) -> Void) {
        services.cakeService.createCake(cake: product, completion: completion)
    }
}

// MARK: - Memory CRUD

extension RootViewModel {
    
    /// Достаём данные товаров из памяти устройства
    func fetchProductsFromMemory() -> [SDProductModel] {
        services.swiftDataService?.fetch() ?? []
    }

    /// Достаём продукт по `id` из памяти
    func fetchProductByID(id: String) -> SDProductModel? {
        let predicate = #Predicate<SDProductModel> { $0._id == id }
        let product = services.swiftDataService?.fetch(predicate: predicate)
        return product
    }

    /// Сохраняем торары в память устройства
    func saveProductsInMemory(products: [FBProductModel]) {
        services.swiftDataService?.create(
            objects: products,
            configureSDModel: {
                let sdModel = SDProductModel(fbModel: $0)
                return sdModel
            },
            configurePredicate: { sdModel in
                let objID = sdModel._id
                return #Predicate<SDProductModel> { $0._id == objID }
            },
            equalCheck: { $0 == $1.mapperInFBProductModel }
        )
    }
    
    /// Добавляем продукт в память устройства
    func addProductInMemory(product: FBProductModel) {
        services.swiftDataService?.create(
            object: product,
            configureSDModel: {
                let sdModel = SDProductModel(fbModel: $0)
                return sdModel
            },
            configurePredicate: { obj in
                let objID = obj._id
                return #Predicate<SDProductModel> { $0._id == objID }
            },
            equalCheck: { $0 == $1.mapperInFBProductModel }
        )
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

    func setContext(context: ModelContext) {
        guard self.context.isNil else { return }
        self.context = context
        services.swiftDataService = SwiftDataService(context: context)
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
    func groupDataBySection(data: [FBProductModel], competion: @escaping CHMGenericBlock<[Section]>) {
        DispatchQueue.global(qos: .userInteractive).async {
            var sales: [ProductModel] = []
            var news: [ProductModel] = []
            var all: [ProductModel] = []
            data.forEach { product in
                switch self.determineSection(for: product) {
                case .news:
                    news.append(product.mapperToProductModel)
                case .sales:
                    sales.append(product.mapperToProductModel)
                case .all:
                    all.append(product.mapperToProductModel)
                }
            }

            DispatchQueue.main.async {
                competion([
                    .sales(sales),
                    .news(news),
                    .all(all)
                ])
            }
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

    /// Фильтруем товары текущего пользователя
    func filterCurrentUserProducts() {
        let userProducts = productData.products.filter { $0.seller.uid == currentUser.uid }
        productData.currentUserProducts = userProducts
    }
}
