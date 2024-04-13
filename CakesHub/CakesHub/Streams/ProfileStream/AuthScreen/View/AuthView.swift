//
//  AuthView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct AuthView: View, ViewModelable {
    typealias ViewModel = AuthViewModel

    #warning("Удалите навигацию, если она не требуется")
    @EnvironmentObject private var nav: Navigation
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension AuthView {

    func onAppear() {
    }
}

// MARK: - Subviews

private extension AuthView {

    var MainView: some View {
        VStack {
            MKRImageView(
                configuration: .basic(
                    kind: viewModel.image,
                    imageShape: .roundedRectangle(Constants.imageCornerRadius)
                )
            )
            .frame(width: Constants.imageSize, height: Constants.imageSize)

            Text(viewModel.title)
                .style(14, .semibold, Constants.textColor)
        }
    }
}

// MARK: - Preview

#Preview {
    AuthView(viewModel: .mockData)
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension AuthView {

    enum Constants {
        static let imageSize: CGFloat = 200
        static let imageCornerRadius: CGFloat = 20
        static let textColor: Color = CHMColor<TextPalette>.textPrimary.color
    }
}
