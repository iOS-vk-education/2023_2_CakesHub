//
//  RootViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 29.03.2024.
//

import SwiftUI

protocol RootViewModelProtocol: AnyObject {
    func fetchData()
}

final class RootViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var currentUser: ProductModel.SellerInfo = .clear
    @Published var currentUserProducts: [ProductModel] = []

    init(products: [ProductModel] = [], currentUser: ProductModel.SellerInfo = .clear, currentUserProducts: [ProductModel] = []) {
        self.products = products
        self.currentUser = currentUser
        self.currentUserProducts = currentUserProducts
    }
}

// MARK: - Network

extension RootViewModel: RootViewModelProtocol {

    func fetchData() {
        products = .mockProducts
        currentUser = .king
        currentUserProducts = products.filter { $0.seller.id == currentUser.id }
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
