//
//  CategoriesViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//

import SwiftUI

// MARK: - CategoriesViewModelProtocol

protocol CategoriesViewModelProtocol {
    func fetchSections()
    func fetchPreviewData()
}

// MARK: - CategoriesViewModel

final class CategoriesViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var firstSections: [CategoryCardModel]
    @Published private(set) var secondSections: [CategoryCardModel]

    init(
        firstSections: [CategoryCardModel] = [],
        secondSections: [CategoryCardModel] = []
    ) {
        self.firstSections = firstSections
        self.secondSections = secondSections
    }
}

// MARK: - Actions

extension CategoriesViewModel: CategoriesViewModelProtocol {

    func fetchSections() {}
}

#if DEBUG
extension CategoriesViewModel {

    func fetchPreviewData() {
        firstSections = Self.mockData.firstSections
        secondSections = Self.mockData.secondSections
    }
}
#endif
