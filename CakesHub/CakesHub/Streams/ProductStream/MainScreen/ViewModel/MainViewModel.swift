//
//  MainViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

// MARK: - MainViewModelProtocol

protocol MainViewModelProtocol: AnyObject {
    func fetchData(completion: CHMVoidBlock?)
    func startViewDidLoad()
    func pullToRefresh(completion: CHMVoidBlock?)
}

// MARK: - MainViewModel

final class MainViewModel: ObservableObject, ViewModelProtocol {

    @Published var sections: [Section] = []
    private(set) var isShimmering: Bool = false

    init() {
        self.sections.reserveCapacity(3)
    }
}

// MARK: - Section

extension MainViewModel {

    enum Section {
        case news([ProductModel])
        case sales([ProductModel])
        case all([ProductModel])
    }
}

extension MainViewModel.Section {

    var itemsCount: Int {
        switch self {
        case let .news(items): return items.count
        case let .sales(items): return items.count
        case let .all(items): return items.count
        }
    }

    var id: Int {
        switch self {
        case .news: return 1
        case .sales: return 2
        case .all: return 3
        }
    }
}

// MARK: - Actions

extension MainViewModel: MainViewModelProtocol {

    func startViewDidLoad() {
        isShimmering = true
        let shimmeringCards: [ProductModel] = (0...3).map { .emptyCards(id: $0) }
        sections.insert(.sales(shimmeringCards), at: 0)
        sections.insert(.news(shimmeringCards), at: 1)
        sections.insert(.all(shimmeringCards), at: 2)
    }

    func fetchData(completion: CHMVoidBlock? = nil) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            asyncMain {
                self.sections[0] = .sales(.mockSalesData)
                self.sections[1] = .news(.mockNewsData)
                self.sections[2] = .all(.mockAllData)
                self.isShimmering = false
                completion?()
            }
        }
    }

    func pullToRefresh(completion: CHMVoidBlock? = nil) {
        completion?()
    }
}

// MARK: - Preview

#if DEBUG
extension MainViewModel {

    func fetchPreviewData(completion: CHMVoidBlock? = nil) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            asyncMain {
                self.sections[0] = .sales(.mockSalesData)
                self.sections[1] = .news(.mockNewsData)
                self.sections[2] = .all(.mockAllData)
                self.isShimmering = false
                completion?()
            }
        }
    }
}
#endif
