//
//  Optional+Extensions.swift
//  CakeHubApplication
//
//  Created by Дмитрий Пермяков on 04.10.2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension Optional {

    var isNil: Bool { self == nil }
}

extension Optional where Wrapped == String {

    var isEmptyOrNil: Bool {
        self == nil || self == ""
    }
}
