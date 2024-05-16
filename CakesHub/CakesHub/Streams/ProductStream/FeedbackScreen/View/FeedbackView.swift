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

    @EnvironmentObject private var root: RootViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(ProductReviewsViewModel.self) var reviewViewModel
    @State var viewModel: ViewModel

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension FeedbackView {

    func onAppear() {
        viewModel.setModels(
            root: root,
            reviewViewModel: reviewViewModel,
            dismiss: dismiss
        )
    }
}

// MARK: - Preview

#Preview {
    FeedbackView(viewModel: .mockData)
        .environment(ProductReviewsViewModel.mockData)
        .environmentObject(RootViewModel.mockData)
}
