//
//  SettingsView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 26.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct SettingsView: View, ViewModelable {
    typealias ViewModel = SettingsViewModel

    @EnvironmentObject private var nav: Navigation
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var root: RootViewModel
    @State var viewModel = ViewModel()

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Lifecycle

private extension SettingsView {

    func onAppear() {
        viewModel.setNavigation(nav: nav, modelContext: modelContext, root: root)
    }
}

// MARK: - Preview

#Preview {
    SettingsView(viewModel: .mockData)
        .environmentObject(Navigation())
}
