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
    // MARK: Actions
    func didTapStar(by index: Int)
    func didTapSendFeedbackButton()
}

// MARK: - FeedbackViewModel

@Observable
final class FeedbackViewModel: ViewModelProtocol {

    var uiProperties: UIProperties

    init(uiProperties: UIProperties = .clear) {
        self.uiProperties = uiProperties
    }
}

// MARK: - Actions

extension FeedbackViewModel: FeedbackViewModelProtocol {
    
    func didTapStar(by index: Int) {
        uiProperties.countFillStars = index
    }

    func didTapSendFeedbackButton() {
        print(uiProperties.countFillStars)
    }
}
