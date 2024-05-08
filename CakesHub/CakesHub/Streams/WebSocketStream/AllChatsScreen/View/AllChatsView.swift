//
//  AllChatsView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct AllChatsView: View, ViewModelable {
    typealias ViewModel = AllChatsViewModel

    @State var viewModel = ViewModel()
    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject private var root: RootViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        MainOrLoadingView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension AllChatsView {

    func onAppear() {
        viewModel.setReducers(modelContext: modelContext, root: root)
        viewModel.onAppear()
    }
}

// MARK: - Preview

#Preview {
    AllChatsView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}
