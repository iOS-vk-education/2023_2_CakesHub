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
    @State var inputText = ""
    @EnvironmentObject private var nav: Navigation
    @EnvironmentObject private var root: RootViewModel

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension AllChatsView {

    func onAppear() {
    }
}

// MARK: - Preview

#Preview {
    AllChatsView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}
