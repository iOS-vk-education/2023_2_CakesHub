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
    @StateObject var viewModel: ViewModel

    // MARK: Properties
    
    @State var selectedTab: CategoriesTab?
    @State var tabBarProgess: CGFloat = .zero
    @State var showSearchBar: Bool = false
    @State var searchText: String = .clear

    // MARK: Lifecycle

    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: View

    var body: some View {
        MainViewBlock
            .onAppear(perform: viewModel.fetchSections)
    }
}

// MARK: - Preview

#Preview {
    let viewModel = CategoriesViewModel()
    return CategoriesView(viewModel: viewModel)
        .onAppear(perform: viewModel.fetchPreviewData)
        .environmentObject(Navigation())
}
