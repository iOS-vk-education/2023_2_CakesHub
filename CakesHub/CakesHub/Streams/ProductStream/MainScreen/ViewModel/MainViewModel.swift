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
//    func groupDataBySection()
//    func startViewDidLoad()
//    func pullToRefresh()
//    func didTapFavoriteButton(id: String, section: MainViewModel.Section, isSelected: Bool)
}

// MARK: - MainViewModel

final class MainViewModel: ObservableObject, ViewModelProtocol {

//    private(set) var rootViewModel: RootViewModel

    init() {
//        self.rootViewModel = rootViewModel
    }
}

// MARK: - Actions

extension MainViewModel: MainViewModelProtocol {

    func pullToRefresh() {}

//    func didTapFavoriteButton(id: String, section: Section, isSelected: Bool) {}
}
