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
    func fetchDataWithoutNetwork()
    func fetchProductsFromMemory() -> [SDProductModel]
    func fetchProductByID(id: String) -> SDProductModel?
    func saveProductsInMemory(products: [FBProductModel])
    func addProductInMemory(product: FBProductModel)
    // MARK: Reducers
    func setCurrentUser(for user: FBUserModel)
    func resetUser()
    func addNewProduct(product: FBProductModel)
    func setContext(context: ModelContext)
    func updateExistedProduct(product: FBProductModel)
    func updateUserName(newNickname: String)
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
        let fbProducts = sdProducts.map { $0.mapper }
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

        // Получаем данные пользователя
        guard let userID = UserDefaults.standard.string(forKey: AuthViewModel.UserDefaultsKeys.currentUser) else {
            return
        }
        let fbUser = try await services.userService.getUserInfo(uid: userID)
        currentUser = fbUser
        saveUserInMemory(user: fbUser)
    }

    @MainActor
    func pullToRefresh() async throws {
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

    func fetchDataWithoutNetwork() {
        let sdProducts = fetchProductsFromMemory()
        let fbProducts = sdProducts.map { $0.mapper }
        productData.products = fbProducts
        filterCurrentUserProducts()
        groupDataBySection(data: fbProducts) { [weak self] sections in
            guard let self else { return }
            productData.sections = sections
            isShimmering = sections.isEmpty
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
        let fetchDescriptor = FetchDescriptor<SDProductModel>()
        return (try? context?.fetch(fetchDescriptor)) ?? []
    }

    /// Достаём продукт по `id` из памяти
    func fetchProductByID(id: String) -> SDProductModel? {
        let predicate = #Predicate<SDProductModel> { $0._id == id }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        let product = try? context?.fetch(fetchDescriptor).first
        return product
    }

    /// Сохраняем торары в память устройства
    func saveProductsInMemory(products: [FBProductModel]) {
        guard let context else {
            Logger.log(kind: .error, message: "context is nil")
            return
        }

        for product in products {
            let sdProduct = SDProductModel(fbModel: product)
            context.insert(sdProduct)
            let seller = SDUserModel(fbModel: product.seller)
            sdProduct._seller = seller
        }

        do { try context.save() }
        catch { Logger.log(kind: .error, message: "context.save() выдал ошибку: \(error.localizedDescription)") }
    }
    
    /// Добавляем продукт в память устройства
    func addProductInMemory(product: FBProductModel) {
        let sdProduct = SDProductModel(fbModel: product)
        self.context?.insert(sdProduct)
        let seller: SDUserModel = SDUserModel(fbModel: product.seller)
        sdProduct._seller = seller
        do { try self.context?.save() }
        catch { Logger.log(kind: .error, message: "context.save() выдал ошибку: \(error.localizedDescription)") }
    }

    /// Кэшируем данные пользователя
    func saveUserInMemory(user: FBUserModel) {
        let sdUser = SDUserModel(fbModel: user)
        context?.insert(sdUser)
        try? context?.save()
    }
}

// MARK: - Reducers

extension RootViewModel {

    @MainActor
    func setCurrentUser(for user: FBUserModel) {
        currentUser = user
        // Фильтруем данные только текущего пользователя
        productData.currentUserProducts = productData.products.filter { $0.seller.uid == currentUser.uid }
    }

    @MainActor
    func resetUser() {
        currentUser = .clear
        productData.currentUserProducts = []
    }

    @MainActor
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

    /// Обновляем данные существующего товара, если таковой имеется
    @MainActor
    func updateExistedProduct(product: FBProductModel) {
        guard
            let index = productData.products.firstIndex(where: { $0.documentID == product.documentID })
        else {
            Logger.log(kind: .error, message: "Не получилось обновить данные товара. Он не найден")
            return
        }
        productData.products[index] = product

        // Обновляем торт в определённой секции
        switch determineSection(for: product) {
        case .news:
            let sectionIndex = 1
            let section = productData.sections[sectionIndex]
            let oldProducts: [ProductModel] = section.products.map {
                $0.id == product.documentID ? product.mapperToProductModel : $0
            }
            productData.sections[sectionIndex] = .news(oldProducts)
        case .sales:
            let sectionIndex = 0
            let section = productData.sections[sectionIndex]
            let oldProducts: [ProductModel] = section.products.map {
                $0.id == product.documentID ? product.mapperToProductModel : $0
            }
            productData.sections[sectionIndex] = .sales(oldProducts)
        case .all:
            let sectionIndex = 2
            let section = productData.sections[sectionIndex]
            let oldProducts: [ProductModel] = section.products.map {
                $0.id == product.documentID ? product.mapperToProductModel : $0
            }
            productData.sections[sectionIndex] = .all(oldProducts)
        }
    }

    @MainActor
    func setContext(context: ModelContext) {
        guard self.context.isNil else { return }
        self.context = context
    }

    @MainActor
    func updateUserImage(newAvatarString: String?) {
        currentUser.avatarImage = newAvatarString
    }

    @MainActor
    func updateUserHeaderImage(newHeaderString: String?) {
        currentUser.headerImage = newHeaderString
    }

    @MainActor
    func updateUserName(newNickname: String) {
        currentUser.nickname = newNickname
    }

    @MainActor
    func deleteProduct(by id: String) {
        // Удаляем торт
        productData.products = productData.products.filter { $0.documentID == id }

        // Удаляём удалённый торт из секции
        for index in 0..<productData.sections.count {
            let currentSection = productData.sections[index]
            if currentSection.products.contains(where: { $0.id == id }) {
                switch currentSection {
                case let .all(products):
                    productData.sections[index] = .all(products.filter { $0.id != id })
                case let .news(products):
                    productData.sections[index] = .news(products.filter { $0.id != id })
                case let .sales(products):
                    productData.sections[index] = .sales(products.filter { $0.id != id })
                }
                break
            }
        }

        // Удаляем торт из товаров пользователя
        let userProducts = productData.currentUserProducts
        productData.currentUserProducts = userProducts.filter({ $0.documentID != id })

        // Удаляем торт из памяти устройства
        do {
            try context?.delete(model: SDProductModel.self, where: #Predicate { $0._id == id })
            try context?.save()
        } catch {
            Logger.log(kind: .error, message: error.localizedDescription)
        }
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
