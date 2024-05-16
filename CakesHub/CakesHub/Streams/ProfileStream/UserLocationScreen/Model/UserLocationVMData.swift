//
//  UserLocationVMData.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import MapKit

extension UserLocationViewModel {

    struct ScreenData: ClearConfigurationProtocol {
        let towel = CLLocationCoordinate2D(
            latitude: 55.76603817707461,
            longitude: 37.685015762493904
        )
        var manager = LocationManager()

        static let clear = ScreenData()
    }
}
