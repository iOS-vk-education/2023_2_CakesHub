//
//  ProfileViewModel.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 25.03.2024.
//

import SwiftUI

// MARK: - ProfileViewModelProtocol

protocol ProfileViewModelProtocol: AnyObject {
    func updateUserProducts(products: [ProductModel])
}

// MARK: - ProfileViewModelProtocol

final class ProfileViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var user: UserModel

    init(user: UserModel = .clear) {
        self.user = user
    }
}

// MARK: - Screens

extension ProfileViewModel {

    enum Screens {
        case message
        case notifications
        case settings
        case createProduct
    }
}

// MARK: - Actions

extension ProfileViewModel: ProfileViewModelProtocol {

    func updateUserProducts(products: [ProductModel]) {
        user.products = products
    }
}
