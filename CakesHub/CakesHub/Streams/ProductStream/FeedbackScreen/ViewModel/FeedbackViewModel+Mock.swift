//
//  FeedbackViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension FeedbackViewModel: Mockable {

    static let mockData = FeedbackViewModel()
}

// MARK: - Constants

private extension FeedbackViewModel {

    enum Constants {
        static let mockTitle = "Просто моковый заголовок из кодогенерации для пример"
    }
}

#endif
