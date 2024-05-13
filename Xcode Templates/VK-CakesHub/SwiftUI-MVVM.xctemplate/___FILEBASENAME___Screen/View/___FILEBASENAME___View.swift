//
//  ___VARIABLE_productName:identifier___View.swift
//  CakesHub
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct ___VARIABLE_productName:identifier___View: View, ViewModelable {
    typealias ViewModel = ___VARIABLE_productName:identifier___ViewModel

    #warning("Удалите навигацию, если она не требуется")
    @EnvironmentObject private var nav: Navigation
    @State var viewModel: ViewModel

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Lifecycle

private extension ___VARIABLE_productName:identifier___View {

    #warning("Тут логика при появлении экрана")
    func onAppear() {
        viewModel.setNavigation(nav: nav)
    }
}

// MARK: - Preview

#warning("Удалите навигацию, если она не требуется")
#Preview {
    ___VARIABLE_productName:identifier___View(viewModel: .mockData)
        .environmentObject(Navigation())
}
