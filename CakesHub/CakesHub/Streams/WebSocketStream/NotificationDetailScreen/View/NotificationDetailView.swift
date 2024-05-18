//
//  NotificationDetailView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct NotificationDetailView: View, ViewModelable {
    typealias ViewModel = NotificationDetailViewModel

    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject private var root: RootViewModel
    @Environment(\.modelContext) private var modelContext
    @State var viewModel: ViewModel

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Lifecycle

private extension NotificationDetailView {

    func onAppear() {
        viewModel.setReducers(nav: nav, root: root, modelContext: modelContext)
        viewModel.onAppear()
    }
}

// MARK: - Actions

extension NotificationDetailView {

    func didTapSellerInfo() {
        viewModel.didTapSellerInfo()
    }

    func didTapCustomerInfo() {
        viewModel.didTapCustomerInfo()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NotificationDetailView(viewModel: .mockData)
    }
    .environmentObject(Navigation())
    .environmentObject(RootViewModel.mockData)
}
