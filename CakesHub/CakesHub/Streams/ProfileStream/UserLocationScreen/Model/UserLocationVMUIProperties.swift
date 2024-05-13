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
        // 55.77142669666473, 37.69194579335664
        var textInput: String = .clear
        var camera: MapCameraPosition = .automatic
        var results: [MKMapItem] = []
        var mapSelection: MKMapItem?
        var showDetails = false

        static let clear = UIProperties()
    }
}
