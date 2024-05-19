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
    func pullToRefresh()
    func didTapFavoriteButton(id: String, section: RootViewModel.Section, isSelected: Bool)
    func setRoot(root: RootViewModel)
}

// MARK: - MainViewModel

final class MainViewModel: ObservableObject, ViewModelProtocol {
    @Published var showLoader: Bool = false
    @Published var root: RootViewModel!
}

// MARK: - MainViewModelProtocol

extension MainViewModel: MainViewModelProtocol {

    @MainActor
    func pullToRefresh() {
        showLoader = true
        Task {
            try? await root.pullToRefresh()
            showLoader = false
        }
    }

    func didTapFavoriteButton(id: String, section: RootViewModel.Section, isSelected: Bool) {
        Logger.log(message: "id: \(id) | section: \(section.title) | isSelected: \(isSelected)")
    }

    func setRoot(root: RootViewModel) {
        self.root = root
    }
}
