//
//  VMCreateProductServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 18.04.2024.
//

import Foundation

extension CreateProductViewModel {

    struct VMServices {
        let cakeService: CakeServiceProtocol
        let fileManager: FileManagerImageHashProtocol

        init(
            cakeService: CakeServiceProtocol = CakeService.shared,
            fileManager: FileManagerImageHashProtocol = FileManagerImageHash.shared
        ) {
            self.cakeService = cakeService
            self.fileManager = fileManager
        }
    }
}
