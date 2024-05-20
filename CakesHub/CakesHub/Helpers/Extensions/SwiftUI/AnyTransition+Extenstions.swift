//
//
//  AnyTransition+Extenstions.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 18.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension AnyTransition {

    static let flip: AnyTransition = .modifier(
        active: FlipTransaction(progress: -1),
        identity: FlipTransaction()
    )

    static let reverseFlip: AnyTransition = .modifier(
        active: FlipTransaction(progress: 1),
        identity: FlipTransaction()
    )
}
