//
//  ___VARIABLE_productName:identifier___ViewModel+Mock.swift
//  CakesHub
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension ___VARIABLE_productName:identifier___ViewModel: Mockable {

    #warning("Обновите, добавив недостоющие переменные")
    static let mockData = ___VARIABLE_productName:identifier___ViewModel(
        title: Constants.mockTitle,
        image: .url(.mockCake2)
    )
}

// MARK: - Constants

#warning("Удалите или замените моковые данные")
private extension ___VARIABLE_productName:identifier___ViewModel {

    enum Constants {
        static let mockTitle = "Просто моковый заголовок из кодогенерации для пример"
    }
}

#endif
