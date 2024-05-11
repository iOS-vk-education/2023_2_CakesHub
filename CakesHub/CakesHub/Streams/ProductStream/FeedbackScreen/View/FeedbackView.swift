//
//  FeedbackView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct FeedbackView: View, ViewModelable {
    typealias ViewModel = FeedbackViewModel

    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject private var root: RootViewModel
    @State var viewModel: ViewModel

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension FeedbackView {

    func onAppear() {
        viewModel.setModels(root: root, nav: nav)
    }
}

// MARK: - Preview

#Preview {
    FeedbackView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}
