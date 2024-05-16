//
//  Modified.swift
//  CHMUIKIT
//
//  Created by Дмитрий Пермяков on 06.10.2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import Foundation

func modify<T>(_ value: T, _ modificator: (inout T) throws -> Void) rethrows -> T {
    var copy = value
    try modificator(&copy)
    return copy
}
