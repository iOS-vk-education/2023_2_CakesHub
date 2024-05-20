//
//  NotificationDetailViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import SwiftData
import Observation

protocol NotificationDetailViewModelProtocol: AnyObject {
    // MARK: Lifecycle
    func onAppear()
    // MARK: Actions
    func didTapSellerInfo()
    func didTapCustomerInfo()
    // MARK: Reducers
    func setReducers(nav: Navigation, root: RootViewModel, modelContext: ModelContext)
}

// MARK: - NotificationDetailViewModel

@Observable
final class NotificationDetailViewModel: ViewModelProtocol, NotificationDetailViewModelProtocol {
    var uiProperties: UIProperties
    private(set) var data: ScreenData
    private var reducers: Reducers

    init(
        uiProperties: UIProperties = .clear,
        data: ScreenData = .clear,
        reducers: Reducers = .clear
    ) {
        self.uiProperties = uiProperties
        self.data = data
        self.reducers = reducers
    }
}
// MARK: - Lifecycle

extension NotificationDetailViewModel {

    func onAppear() {
        guard let product = reducers.root.productData.products.first(where: {
            $0.documentID == data.notification.productID
        }) else {
            return
        }

        data.product = product
        var currentUserID: String { reducers.root.currentUser.uid }
        var notification: FBNotification { data.notification }

        if product.seller.uid == currentUserID {
            let customerID: String
            if notification.creatorID == currentUserID {
                customerID = notification.receiverID
            } else {
                customerID = notification.creatorID
            }
            data.customer = fetchUser(by: customerID)?.mapper
            data.deliveryAddress = data.customer?.address
        } else {
            let sellerID: String
            if notification.creatorID == currentUserID {
                sellerID = notification.receiverID
            } else {
                sellerID = notification.creatorID
            }
            data.seller = fetchUser(by: sellerID)?.mapper
            data.deliveryAddress = reducers.root.currentUser.address
        }
    }
}

// MARK: - Actions

extension NotificationDetailViewModel {

    /// Нажали ячейку продавца
    func didTapSellerInfo() {
        guard let seller = data.seller else { return }
        let userModel = didTapUserInfo(for: seller)
        reducers.nav.addScreen(screen: userModel)
    }
    
    /// Нажали ячейку покупателя
    func didTapCustomerInfo() {
        guard let customer = data.customer else { return }
        let userModel = didTapUserInfo(for: customer)
        reducers.nav.addScreen(screen: userModel)
    }

    private func didTapUserInfo(for user: FBUserModel) -> UserModel {
        let sellerInfo: ProductModel.SellerInfo = user.mapper
        let userProducts = reducers.root.productData.products.filter {
            $0.seller.uid == user.uid
        }
        let userModel = sellerInfo.mapper(products: userProducts.mapperToProductModel)
        return userModel
    }
}

// MARK: - Memory

extension NotificationDetailViewModel {

    func fetchUser(by id: String) -> SDUserModel? {
        let fetchDescriptor = FetchDescriptor<SDUserModel>(predicate: #Predicate { $0._id == id })
        return try? reducers.modelContext.fetch(fetchDescriptor).first
    }
}

// MARK: - Reducers

extension NotificationDetailViewModel {

    func setReducers(nav: Navigation, root: RootViewModel, modelContext: ModelContext) {
        reducers.nav = nav
        reducers.root = root
        reducers.modelContext = modelContext
    }
}
