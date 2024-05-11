//
//
//  FeedbackVMUIProperties.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension FeedbackViewModel {

    struct UIProperties: ClearConfigurationProtocol {
        var countFillStars: Int = 1
        var feedbackText: String = .clear
        var isShowLoading: Bool = false

        static let clear = UIProperties()
    }
}
