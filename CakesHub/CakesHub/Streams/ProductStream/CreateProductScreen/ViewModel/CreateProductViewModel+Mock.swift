//
//  CreateProductViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension CreateProductViewModel: Mockable {

    static let mockData = CreateProductViewModel(rootViewModel: .mockData)
}

// MARK: - Constants

private extension CreateProductViewModel {

    enum Constants {
        static let mockTitle = "Просто моковый заголовок из кодогенерации для пример"
    }
}

#endif
