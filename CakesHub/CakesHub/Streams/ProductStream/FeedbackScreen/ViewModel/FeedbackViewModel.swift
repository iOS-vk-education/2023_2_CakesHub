//
//  FeedbackViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - FeedbackViewModelProtocol

protocol FeedbackViewModelProtocol: AnyObject {
    // MARK: Network
    func sendFeedback(username: String) async throws -> FBProductModel
    // MARK: Actions
    func didTapStar(by index: Int)
    func didTapSendFeedbackButton()
    // MARK: Reducers
    func setModels(root: RootViewModel, nav: Navigation)
}

// MARK: - FeedbackViewModel

@Observable
final class FeedbackViewModel: ViewModelProtocol, FeedbackViewModelProtocol {

    var uiProperties: UIProperties
    var data: ScreenData
    var cakeService: CakeServiceProtocol

    init(
        data: ScreenData,
        uiProperties: UIProperties = .clear,
        cakeService: CakeServiceProtocol = CakeService.shared
    ) {
        self.data = data
        self.uiProperties = uiProperties
        self.cakeService = cakeService
    }
}

// MARK: - Network

extension FeedbackViewModel {

    func sendFeedback(username: String) async throws -> FBProductModel {
        try await cakeService.sendFeedback(
            productID: data.productID,
            text: uiProperties.feedbackText,
            count: uiProperties.countFillStars,
            username: username
        )
    }
}

// MARK: - Actions

extension FeedbackViewModel {
    
    func didTapStar(by index: Int) {
        uiProperties.countFillStars = index
    }

    func didTapSendFeedbackButton() {
        guard  let root = data.root else {
            Logger.log(kind: .error, message: "Текущий пользователь isNil. Вероятно setRootViewModel не был вызыван")
            return
        }

        Task {
            do {
                let updatedProduct = try await sendFeedback(username: root.currentUser.nickname)
                await MainActor.run {
                    root.updateExistedProduct(product: updatedProduct)
                    data.nav?.openPreviousScreen()
                }
            } catch {
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Reducers

extension FeedbackViewModel {

    func setModels(root: RootViewModel, nav: Navigation) {
        self.data.root = root
        self.data.nav = nav
    }
}
