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
        data: .init(
            title: Constants.mockTitle,
            imageKind: Constants.mockImage
        )
    )
}

// MARK: - Constants

#warning("Удалите или замените моковые данные")
private extension ___VARIABLE_productName:identifier___ViewModel {

    enum Constants {
        static let mockTitle = "Просто моковый заголовок из кодогенерации для пример"
        static let mockImage: ImageKind = .uiImage(.cake2)
    }
}

#endif
