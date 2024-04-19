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
    func fetchProductsFromMemory() -> [FBProductModel]
    func fetchProductByID(id: String) -> SDProductModel?
    func isExist(by product: FBProductModel) -> Bool
    func saveProductsInMemory(products: [FBProductModel])
    func addProductInMemory(product: FBProductModel)
    // MARK: Reducers
    func setCurrentUser(for user: FBUserModel)
    func addNewProduct(product: FBProductModel)
    func setContext(context: ModelContext)
}

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
        groupDataBySection(data: sdProducts) { [weak self] sections in
            guard let self else { return }
            productData.sections = sections
            isShimmering = false
        }
//        return
        // Достаём данные из сети
        let fbProucts = try await services.cakeService.getCakesList()

        // Кэшируем данные
        saveProductsInMemory(products: fbProucts)

//        let uniqueProducts = fbProucts.filter { fbProduct in
//            !sdProducts.contains(where: { $0.documentID == fbProduct.documentID })
//        }

        // Группируем данные по секциям
        groupDataBySection(data: fbProucts) { [weak self] sections in
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
    func fetchProductsFromMemory() -> [FBProductModel] {
        let sdProduct: [SDProductModel] = services.swiftDataService?.fetchData() ?? []
        return sdProduct.map { $0.mapperInFBProductModel }
    }

    /// Достаём продукт по `id` из памяти
    func fetchProductByID(id: String) -> SDProductModel? {
        let predicate = #Predicate<SDProductModel> { $0._id == id }
        let product = services.swiftDataService?.fetchObject(predicate: predicate)
        return product
    }

    /// Проверка на наличие в памяти продукта по `id`
    func isExist(by product: FBProductModel) -> Bool {
        guard let oldProductFromBD = fetchProductByID(id: product.documentID) else {
            return false
        }

        // Если свойства модели изменились, продукт будет перезаписан в памяти
        let oldProduct = oldProductFromBD.mapperInFBProductModel
        return product == oldProduct
    }

    /// Сохраняем торары в память устройства
    func saveProductsInMemory(products: [FBProductModel]) {
        services.swiftDataService?.writeObjects(objects: products, sdType: SDProductModel.self)
    }
    
    /// Добавляем продукт в память устройства
    func addProductInMemory(product: FBProductModel) {
        DispatchQueue.global(qos: .utility).async {
            let sdProduct = SDProductModel(fbModel: product)
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
}
