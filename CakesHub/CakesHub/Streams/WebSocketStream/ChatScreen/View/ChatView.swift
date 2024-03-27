//
//  ChatView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct ChatView: View, ViewModelable {
    typealias ViewModel = ChatViewModel

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

private extension ChatView {

    #warning("Тут логика при появлении экрана")
    func onAppear() {
    }
}

// MARK: - Subviews

private extension ChatView {

    #warning("Тут должна быть вашь вьюха")
    var MainView: some View {
        VStack {
            MKRImageView(
                configuration: .basic(
                    kind: viewModel.image,
                    imageSize: CGSize(width: Constants.imageSize, height: Constants.imageSize),
                    imageShape: .roundedRectangle(Constants.imageCornerRadius)
                )
            )

            Text(viewModel.title)
                .style(14, .semibold, Constants.textColor)
        }
    }
}

// MARK: - Preview

#warning("Удалите навигацию, если она не требуется")
#Preview {
    ChatView(viewModel: .mockData)
        .environmentObject(Navigation())
}

// MARK: - Constants

#warning("Добавляйте сюда все необходимые константы")
private extension ChatView {

    enum Constants {
        static let imageSize: CGFloat = 200
        static let imageCornerRadius: CGFloat = 20
        static let textColor: Color = CHMColor<TextPalette>.textPrimary.color
    }
}
