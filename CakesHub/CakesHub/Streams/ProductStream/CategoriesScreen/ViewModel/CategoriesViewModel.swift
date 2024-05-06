//
//  CategoriesViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//

import SwiftUI
import Observation

// MARK: - CategoriesViewModelProtocol

protocol CategoriesViewModelProtocol {
    // MARK: Network
    func fetch() async throws -> [CategoriesViewModel.Section]
    // MARK: Lifecycle
    func fetchSections()
    // MARK: Actions
    func didTapSectionCell(title: String) -> [FBProductModel]
    // MARK: Reducers
    func setRootViewModel(with rootViewModel: RootViewModel)
}

// MARK: - CategoriesViewModel

@Observable
final class CategoriesViewModel: ViewModelProtocol, CategoriesViewModelProtocol {
    private(set) var sections: [Section]
    private(set) var services: CategoriesVMServices
    private(set) var rootViewModel: RootViewModel!
    var uiProperties: CategoriesUIProperties

    init(
        sections: [Section] = [],
        services: CategoriesVMServices = .clear,
        uiProperties: CategoriesUIProperties = .clear
    ) {
        self.sections = sections
        self.services = services
        self.uiProperties = uiProperties
        self.sections.reserveCapacity(3)
    }
}

// MARK: - Lifecycle

extension CategoriesViewModel {

    @MainActor
    func fetchSections() {
        Task {
            do {
                let sections = try await fetch()
                withAnimation {
                    self.sections = sections
                }
            } catch {
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Actions

extension CategoriesViewModel {

    /// Нажали на ячейку секции
    func didTapSectionCell(title: String) -> [FBProductModel] {
        rootViewModel.productData.products.filter { product in
            product.categories.contains(title)
        }
    }
}

// MARK: - Network

extension CategoriesViewModel {

    func fetch() async throws -> [Section] {
        async let kidsCategories = services.catigoryService.fetch(tags: [.kids])
        async let menCategories = services.catigoryService.fetch(tags: [.men])
        async let womenCategories = services.catigoryService.fetch(tags: [.women])

        let section: [Section] = [
            .men(try await menCategories.map { $0.mapper }),
            .women(try await womenCategories.map { $0.mapper }),
            .kids(try await kidsCategories.map { $0.mapper })
        ]

        return section
    }
}

// MARK: - Reducers

extension CategoriesViewModel {

    func setRootViewModel(with rootViewModel: RootViewModel) {
        self.rootViewModel = rootViewModel
    }
}
