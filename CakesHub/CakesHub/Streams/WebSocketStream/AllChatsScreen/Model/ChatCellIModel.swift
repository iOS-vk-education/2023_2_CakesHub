//
//
//  ChatCellIModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

struct ChatCellIModel: Identifiable {
    let userName: String
    let imageKind: ImageKind
    let lastMessage: String
    let timeMessage: String

    var id: String { userName }
}

