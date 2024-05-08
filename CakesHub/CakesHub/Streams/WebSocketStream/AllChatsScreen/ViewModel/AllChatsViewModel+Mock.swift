//
//  AllChatsViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension AllChatsViewModel: Mockable {

    static let mockData = AllChatsViewModel(
        chatCells: Constants.cells
    )
}

// MARK: - Constants

private extension AllChatsViewModel {

    enum Constants {
        static let cells: [ChatCellIModel] = [
            .init(
                userName: "Dmitriy Permyakov",
                imageKind: .url(.mockKingImage),
                lastMessage: "Привет! Это последнее сообщение",
                timeMessage: "03:12"
            ),
            .init(
                userName: "Полиночка",
                imageKind: .uiImage(.bestGirl2),
                lastMessage: "А это ещё одно сообщение",
                timeMessage: "02:12"
            )
        ]
    }
}

#endif
