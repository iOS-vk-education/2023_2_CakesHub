//
//  ___VARIABLE_productName:identifier___ViewModel.swift
//  CakesHub
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation
import Observation

protocol ___VARIABLE_productName:identifier___ViewModelProtocol: AnyObject {
    // MARK: Reducers
    func setNavigation(nav: Navigation)
}

// MARK: - ___VARIABLE_productName:identifier___ViewModel

#warning("Замените переменные на необходимые")
@Observable
final class ___VARIABLE_productName:identifier___ViewModel: ViewModelProtocol, ___VARIABLE_productName:identifier___ViewModelProtocol {
    var uiProperties: UIProperties
    private(set) var data: ScreenData
    private var reducers: Reducers

    init(
        uiProperties: UIProperties = .clear,
        data: ScreenData = .clear,
        reducers: Reducers = .clear
    ) {
        self.uiProperties = uiProperties
        self.data = data
        self.reducers = reducers
    }
}

// MARK: - Actions

extension ___VARIABLE_productName:identifier___ViewModel {}

// MARK: - Reducers

extension ___VARIABLE_productName:identifier___ViewModel {

    func setNavigation(nav: Navigation) {
        reducers.nav = nav
    }
}
