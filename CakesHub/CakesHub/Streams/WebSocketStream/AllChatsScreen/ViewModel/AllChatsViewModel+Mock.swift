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
        static let cells: [ChatCellModel] = [
            .init(
                user: .init(id: king.uid, nickname: king.nickname, imageKind: .string(king.avatarImage ?? .clear)),
                lastMessage: "Привет! Это последнее сообщение",
                timeMessage: Date()
            ),
            .init(
                user: .init(id: poly.uid, nickname: poly.nickname, imageKind: .string(poly.avatarImage ?? .clear)),
                lastMessage: "А это ещё одно сообщение",
                timeMessage: Date()
            )
        ]

        private static let king = FBUserModel.king
        private static let poly = FBUserModel.poly
    }
}

#endif
