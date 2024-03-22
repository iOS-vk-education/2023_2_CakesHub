//
//  NewProductDetailViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import Combine

protocol NewDetailScreenViewModelProtocol {
    func didTapLikeButton(isSelected: Bool, completion: CHMVoidBlock?)
    func didTapBuyButton()
}

final class ProductDetailViewModel: ViewModelProtocol, ObservableObject {

    @Published var currentProduct: ProductModel

    init(data: ProductModel) {
        self.currentProduct = data
    }
}

// MARK: Network

extension ProductDetailViewModel: NewDetailScreenViewModelProtocol {

    func didTapLikeButton(isSelected: Bool, completion: CHMVoidBlock?) {}
    
    func didTapBuyButton() {}
}
