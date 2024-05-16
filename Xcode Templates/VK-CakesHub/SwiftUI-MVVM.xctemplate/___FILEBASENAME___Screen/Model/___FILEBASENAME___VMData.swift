//
//  ___VARIABLE_productName:identifier___VMData.swift
//  CakesHub
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

extension ___VARIABLE_productName:identifier___ViewModel {

    #warning("Добавьте сюда все объекты данных")
    struct ScreenData: ClearConfigurationProtocol {
        var title: String
        var imageKind: ImageKind

        init(title: String = .clear, imageKind: ImageKind = .clear) {
            self.title = title
            self.imageKind = imageKind
        }

        static let clear = ScreenData()
    }
}
