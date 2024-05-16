//
//
//  FeedbackSubview.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension FeedbackView {

    var MainView: some View {
        VStack(spacing: 0) {
            StarsBlock

            TitleBlock
                .padding(.top, 32)

            TextInputBlock
                .padding(.top, 18)

            SendFeedbackButtonView
                .padding(.top, 18)
        }
        .background(Constants.bgColor)
        .overlay {
            if viewModel.uiProperties.isShowLoading {
                ProgressView()
            }
        }
    }

    var StarsBlock: some View {
        VStack {
            Text(Constants.ratingTitle)
                .style(18, .semibold, Constants.titleColor)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { index in
                    Image(
                        index > viewModel.uiProperties.countFillStars ? .starOutline : .starFill
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(edge: 36)
                    .padding(5)
                    .contentShape(.rect)
                    .onTapGesture {
                        viewModel.didTapStar(by: index)
                    }
                }
            }
        }
    }

    var TitleBlock: some View {
        Text(Constants.title)
            .style(18, .semibold, Constants.titleColor)
            .padding(.horizontal, 70)
            .multilineTextAlignment(.center)
    }

    var TextInputBlock: some View {
        LimitedTextField(
            config: .init(
                limit: 550,
                tint: Constants.titleColor,
                autoResizes: false,
                allowsExcessTyping: false,
                submitLabel: .return,
                progressConfig: .init(
                    showsRing: true,
                    showsText: true,
                    alignment: .trailing
                ),
                borderConfig: .init(
                    show: true,
                    radius: 6,
                    width: 1
                )
            ),
            hint: Constants.feedbackPlaceholder,
            value: $viewModel.uiProperties.feedbackText
        )
        .padding(.horizontal)
    }

    var SendFeedbackButtonView: some View {
        Button(action: viewModel.didTapSendFeedbackButton, label: {
            Text(Constants.sendFeedbackTitle.uppercased())
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity)
        })
        .padding(.vertical, 14)
        .background(Constants.sendFeedbackButtonColor, in: .rect(cornerRadius: 25))
        .padding(.horizontal)
        .tint(Color.white)
        .padding(.bottom, 6)
    }
}

// MARK: - Preview

#Preview {
    FeedbackView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel.mockData)
}

// MARK: - Constants

private extension FeedbackView {

    enum Constants {
        static let ratingTitle = String(localized: "What is you rate?")
        static let title = String(localized: "Please share your opinion about the product")
        static let feedbackPlaceholder = String(localized: "Your feedback")
        static let sendFeedbackTitle = String(localized: "Send review")
        static let titleColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
        static let sendFeedbackButtonColor = CHMColor<BackgroundPalette>.bgRed.color
    }
}
