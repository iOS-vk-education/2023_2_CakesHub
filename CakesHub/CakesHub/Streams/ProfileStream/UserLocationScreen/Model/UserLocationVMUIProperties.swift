//
//  UserLocationVMUIProperties.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI
import MapKit

extension UserLocationViewModel {

    struct UIProperties: ClearConfigurationProtocol {
        var textInput: String = .clear
        var camera: MapCameraPosition = .region(
            .init(
                center: CLLocationCoordinate2D(
                    latitude: 55.76603817707461,
                    longitude: 37.685015762493904
                ),
                latitudinalMeters: 10_000,
                longitudinalMeters: 10_000
            )
        )
        var results: [MKMapItem] = []
        var mapSelection: MKMapItem?
        var showDetails = false

        static let clear = UIProperties()
    }
}
