//
//  Optional+Extensions.swift
//  CakeHubApplication
//
//  Created by Дмитрий Пермяков on 04.10.2023.
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
