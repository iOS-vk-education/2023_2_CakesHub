//
//  AuthViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension AuthViewModel: Mockable {

    #warning("Обновите, добавив недостоющие переменные")
    static let mockData = AuthViewModel(
        title: Constants.mockTitle,
        image: .url(.mockCake2)
    )
}

// MARK: - Constants

#warning("Удалите или замените моковые данные")
private extension AuthViewModel {

    enum Constants {
        static let mockTitle = "Просто моковый заголовок из кодогенерации для пример"
    }
}

#endif
