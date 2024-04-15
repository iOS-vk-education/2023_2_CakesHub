//
//  ChatViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG
extension ChatViewModel: Mockable {

    static let mockData = ChatViewModel(
        messages: .mockData,
        seller: .mockData,
        user: .king
    )
}
#endif
