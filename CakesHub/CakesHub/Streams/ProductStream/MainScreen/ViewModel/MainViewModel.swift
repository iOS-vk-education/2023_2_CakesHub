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
}

// MARK: - MainViewModel

final class MainViewModel: ObservableObject, ViewModelProtocol {
}

// MARK: - Actions

extension MainViewModel: MainViewModelProtocol {

    func pullToRefresh() {}

    func didTapFavoriteButton(id: String, section: RootViewModel.Section, isSelected: Bool) {
        Logger.log(message: "id: \(id) | section: \(section.title) | isSelected: \(isSelected)")
    }
}
