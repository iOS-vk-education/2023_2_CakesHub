//
//  CreateProductViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - CreateProductViewModelProtocol

protocol CreateProductViewModelProtocol: AnyObject {}

// MARK: - CreateProductViewModel

#warning("Замените переменные на необходимые")
final class CreateProductViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var title: String
    @Published private(set) var image: ImageKind

    init(title: String = .clear, image: ImageKind = .clear) {
        self.title = title
        self.image = image
    }
}

// MARK: - Actions

extension CreateProductViewModel: CreateProductViewModelProtocol {}
