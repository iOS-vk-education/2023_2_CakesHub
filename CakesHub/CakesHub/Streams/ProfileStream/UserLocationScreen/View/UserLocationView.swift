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
        viewModel.setNavigation(nav: nav)
    }
}

// MARK: - Preview

#Preview {
    UserLocationView()
        .environmentObject(Navigation())
}
