//
//  ChatViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - ChatViewModelProtocol

protocol ChatViewModelProtocol: AnyObject {}

// MARK: - ChatViewModel

#warning("Замените переменные на необходимые")
final class ChatViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var title: String
    @Published private(set) var image: ImageKind

    init(title: String = .clear, image: ImageKind = .clear) {
        self.title = title
        self.image = image
    }
}

// MARK: - Actions

extension ChatViewModel: ChatViewModelProtocol {}
