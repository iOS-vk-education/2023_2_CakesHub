//
//  CategoriesViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//

import SwiftUI
import SwiftData
import Observation

// MARK: - CategoriesViewModelProtocol

protocol CategoriesViewModelProtocol {
    // MARK: Network
    func fetch() async throws -> [CategoriesViewModel.FBSection]
    // MARK: Memory CRUD
    func save(categories: Set<FBCateoryModel>)
    func fetch() -> [FBCateoryModel]
    // MARK: Lifecycle
    func fetchSections()
    func fetchSectionsFromMemory() -> [CategoriesViewModel.Section]
    // MARK: Actions
    func didTapSectionCell(title: String) -> [FBProductModel]
    // MARK: Reducers
    func setRootViewModel(with rootViewModel: RootViewModel)
    func setModelContext(with context: ModelContext)
}

// MARK: - CategoriesViewModel

@Observable
final class CategoriesViewModel: ViewModelProtocol, CategoriesViewModelProtocol {
    private(set) var sections: [Section]
    private(set) var services: CategoriesVMServices
    private(set) var rootViewModel: RootViewModel!
    private var modelContext: ModelContext!
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
        // Если данные уже были полученны, повторного захода в сеть не делаем
        guard sections.isEmpty else { return }

        // Делаем запрос в сеть для получения категорий
        Task {
            do {
                // Получаем данный категорий из сети
                let fbSections = try await fetch()
                withAnimation {
                    sections = [
                        .men(fbSections[0].items.sorted(by: { $0.title < $1.title }).mapper),
                        .women(fbSections[1].items.sorted(by: { $0.title < $1.title }).mapper),
                        .kids(fbSections[2].items.sorted(by: { $0.title < $1.title }).mapper)
                    ]
                }

                // Кэшируем данные категорий
                let memorySectionsArray = fbSections.map { $0.items }
                let memorySections = memorySectionsArray.flatMap { $0 }
                let setMemorySections = Set(memorySections)
                save(categories: setMemorySections)

            } catch {
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
        
        // Получаем данный категорий из памяти устройства
        withAnimation {
            sections = fetchSectionsFromMemory()
        }
    }

    func fetchSectionsFromMemory() -> [Section] {
        let memoryCategories = fetch()

        var menCategories: [FBCateoryModel] = []
        var womenCategories: [FBCateoryModel] = []
        var kidsCategories: [FBCateoryModel] = []
        for category in memoryCategories {
            if category.tags.contains(.men) {
                menCategories.append(category)
            }
            if category.tags.contains(.women) {
                womenCategories.append(category)
            }
            if category.tags.contains(.kids) {
                kidsCategories.append(category)
            }
        }

        return [
            .men(menCategories.sorted(by: { $0.title < $1.title }).mapper),
            .women(womenCategories.sorted(by: { $0.title < $1.title }).mapper),
            .kids(kidsCategories.sorted(by: { $0.title < $1.title }).mapper)
        ]
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

// MARK: - Memory CRUD

extension CategoriesViewModel {

    func save(categories: Set<FBCateoryModel>) {
        categories.forEach { category in
            let sdModel = SDCateoryModel(fbModel: category)
            modelContext.insert(sdModel)
        }
        try? modelContext.save()
    }

    func fetch() -> [FBCateoryModel] {
        let fetchDescriptor = FetchDescriptor<SDCateoryModel>()
        let sdModels = (try? modelContext.fetch(fetchDescriptor)) ?? []
        return sdModels.map { $0.mapper }
    }
}

// MARK: - Network

extension CategoriesViewModel {

    func fetch() async throws -> [FBSection] {
        async let kidsCategories = services.catigoryService.fetch(tags: [.kids])
        async let menCategories = services.catigoryService.fetch(tags: [.men])
        async let womenCategories = services.catigoryService.fetch(tags: [.women])

        let categories: [FBSection] = [
            .men(try await menCategories),
            .women(try await womenCategories),
            .kids(try await kidsCategories)
        ]

        return categories
    }
}

// MARK: - Reducers

extension CategoriesViewModel {

    func setRootViewModel(with rootViewModel: RootViewModel) {
        self.rootViewModel = rootViewModel
    }

    func setModelContext(with context: ModelContext) {
        self.modelContext = context
    }
}
