//
//  ___VARIABLE_productName:identifier___ViewModel.swift
//  CakesHub
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

// MARK: - ___VARIABLE_productName:identifier___ViewModelProtocol

protocol ___VARIABLE_productName:identifier___ViewModelProtocol: AnyObject {}

// MARK: - ___VARIABLE_productName:identifier___ViewModel

#warning("Замените переменные на необходимые")
final class ___VARIABLE_productName:identifier___ViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var title: String
    @Published private(set) var image: ImageKind

    init(title: String = .clear, image: ImageKind = .clear) {
        self.title = title
        self.image = image
    }
}

// MARK: - Actions

extension ___VARIABLE_productName:identifier___ViewModel: ___VARIABLE_productName:identifier___ViewModelProtocol {}
