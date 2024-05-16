//
//  UserLocationView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct UserLocationView: View, ViewModelable {
    typealias ViewModel = UserLocationViewModel

    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject private var root: RootViewModel
    @Environment(\.modelContext) private var modelContext
    @State var viewModel = ViewModel()
    @State var locationManager = LocationManager()

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Lifecycle

private extension UserLocationView {

    func onAppear() {
        viewModel.setReducers(nav: nav, root: root, modelContext: modelContext)
    }
}

// MARK: - Preview

#Preview {
    UserLocationView()
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}
