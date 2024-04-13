//
//  AuthViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - AuthViewModelProtocol

protocol AuthViewModelProtocol: AnyObject {}

// MARK: - AuthViewModel

final class AuthViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var title: String
    @Published private(set) var image: ImageKind

    init(title: String = .clear, image: ImageKind = .clear) {
        self.title = title
        self.image = image
    }
}

// MARK: - Actions

extension AuthViewModel: AuthViewModelProtocol {}
