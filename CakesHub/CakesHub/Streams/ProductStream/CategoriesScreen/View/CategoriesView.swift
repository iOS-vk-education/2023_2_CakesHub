//
//  CategoriesView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.02.2024.
//

import SwiftUI

struct CategoriesView: View {
    
    // MARK: View Model

    typealias ViewModel = CategoriesViewModel
    @State private(set) var viewModel = ViewModel()
    @EnvironmentObject private var root: RootViewModel

    // MARK: View

    var body: some View {
        MainViewBlock
            .onAppear(perform: onAppear)
    }
}

// MARK: - Actions

private extension CategoriesView {

    func onAppear() {
        viewModel.setRootViewModel(with: root)
        viewModel.fetchSections()
    }
}

// MARK: - Preview

#Preview {
    CategoriesView()
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}
