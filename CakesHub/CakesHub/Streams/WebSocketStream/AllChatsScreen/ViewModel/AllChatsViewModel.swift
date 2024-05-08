//
//  AllChatsViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - AllChatsViewModelProtocol

protocol AllChatsViewModelProtocol: AnyObject {}

// MARK: - AllChatsViewModel

@Observable
final class AllChatsViewModel: ViewModelProtocol {

    private let services: Services
    private(set) var chatCells: [ChatCellIModel]
    var uiProperties: UIProperties

    init(
        chatCells: [ChatCellIModel] = [],
        services: Services = .clear,
        uiProperties: UIProperties = .clear
    ) {
        self.chatCells = chatCells
        self.services = services
        self.uiProperties = uiProperties
    }

    var filterInputText: [ChatCellIModel] {
        uiProperties.searchText.isEmpty
        ? chatCells
        : chatCells.filter { $0.userName.contains(uiProperties.searchText) }
    }
}

// MARK: - Actions

extension AllChatsViewModel: AllChatsViewModelProtocol {

}
