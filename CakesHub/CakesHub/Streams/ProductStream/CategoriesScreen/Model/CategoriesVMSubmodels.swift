//
//  CategoriesVMSubmodels.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.05.2024.
//

import Foundation

// MARK: - Section

extension CategoriesViewModel {

    enum Section {
        case men([CategoryCardModel])
        case women([CategoryCardModel])
        case kids([CategoryCardModel])
    }
}

extension CategoriesViewModel.Section: Identifiable{

    var id: Int {
        switch self {
        case .men: return 1
        case .women: return 2
        case .kids: return 3
        }
    }
}

// MARK: - Screens

extension CategoriesViewModel {

    enum Screens {
        case sectionCakes([FBProductModel])
    }
}

extension CategoriesViewModel.Screens: Identifiable, Hashable {

    var id: Int {
        switch self {
        case .sectionCakes: return 1
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
