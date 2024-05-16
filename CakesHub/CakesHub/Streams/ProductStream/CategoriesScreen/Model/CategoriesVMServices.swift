//
//  CategoriesVMServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension CategoriesViewModel {

    struct CategoriesVMServices: ClearConfigurationProtocol {
        let catigoryService: CategoryServiceProtocol

        init(catigoryService: CategoryServiceProtocol = CategoryService.shared) {
            self.catigoryService = catigoryService
        }

        static let clear = CategoriesVMServices()
    }
}
