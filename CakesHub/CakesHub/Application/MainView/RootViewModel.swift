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
    @Published var currentUser: ProductModel.SellerInfo = .clear
    @Published var currentUserProducts: [ProductModel] = []
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
    }
}

// MARK: - Network

extension RootViewModel: RootViewModelProtocol {

    @MainActor
    func fetchData() async throws {
        let cakes: [ProductRequest] = try await cakeService.getCakesList()
//        Logger.log(message: cakes)
        products = cakes.mapperToProductModel
        Logger.log(message: products)
//        products = .mockProducts
        // TODO: Кэшировать торты пользователя
//        currentUser = .king
        currentUserProducts = products.filter { $0.seller.id == currentUser.id }
    }

    func fetchDataFromMemory() {

    }

    func saveUserProductsInMemory() {
//        let products: [SDProductModel] = currentUserProducts.map {
//
//        }
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
