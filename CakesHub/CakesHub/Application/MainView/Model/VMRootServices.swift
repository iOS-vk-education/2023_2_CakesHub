//
//  VMRootServices.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.04.2024.
//

import Foundation

extension RootViewModel {

    struct Services: ClearConfigurationProtocol {
        let cakeService: CakeServiceProtocol
        var swiftDataService: SwiftDataServiceProtocol?

        init(
            cakeService: CakeServiceProtocol = CakeService.shared,
            swiftDataService: SwiftDataServiceProtocol? = nil
        ) {
            self.cakeService = cakeService
            self.swiftDataService = swiftDataService
        }

        static let clear: RootViewModel.Services = .init()
    }
}
