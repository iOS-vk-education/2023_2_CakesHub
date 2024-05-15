//
//  ProductReviewsSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

// MARK: - Subviews

extension ProductReviewsScreen {

    var MainBlock: some View {
        ScrollView {
            RatingBlock
                .padding(.horizontal)
                .padding(.top, 37)

            SectionTitle

            ReviewsBlock
        }
        .overlay(alignment: .bottomTrailing) {
            WriteReviewButton
                .padding(.trailing, 26)
        }
    }

    var RatingBlock: some View {
        CHMRatingReviewsView(
            configuration: .basic(
                fiveStarRating: viewModel.data.fiveStarsConfiguration,
                fourStarRating: viewModel.data.fourStarsConfiguration,
                threeStarRating: viewModel.data.threeStarsConfiguration,
                twoStarRating: viewModel.data.twoStarsConfiguration,
                oneStarRating: viewModel.data.oneStarsConfiguration,
                commonRating: viewModel.data.averageRatingString,
                commonCount: Constants.sectionTitle(count: viewModel.data.feedbackCount)
            )
        )
    }

    var SectionTitle: some View {
        Text(Constants.sectionTitle(count: viewModel.data.countOfComments).capitalized)
            .style(24, .semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.init(top: 37, leading: 16, bottom: 30, trailing: 32))
    }

    var ReviewsBlock: some View {
        LazyVStack {
            ForEach(viewModel.data.comments) { comment in
                ReviewCell(comment: comment)
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 32)
    }

    var WriteReviewButton: some View {
        Button(action: didTapWriteReviewButton, label: {
            HStack(spacing: 9) {
                Image(.pen)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(edge: 13)

                Text(Constants.writeReviewButtonTitle)
                    .style(11, .semibold, .white)
            }
        })
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(CHMColor<BackgroundPalette>.bgRed.color, in: .rect(cornerRadius: 25))
    }

    var SheetView: some View {
        FeedbackView(
            viewModel: FeedbackViewModel(
                data: .init(productID: viewModel.productID)
            )
        )
        .environment(viewModel)
        .padding(.top)
    }
}

// MARK: - ReviewCell

fileprivate struct ReviewCell: View {
    var comment: ProductReviewsModel.CommentInfo

    var body: some View {
        CHMCommentView(
            configuration: .basic(
                imageKind: .url(.mockProductCard),
                userName: comment.userName,
                date: comment.date,
                description: comment.description,
                starsConfiguration: .basic(
                    kind: .init(rawValue: comment.countFillStars) ?? .zero
                )
            )
        )
    }
}

// MARK: - Constants

private extension ProductReviewsScreen {

    enum Constants {
        static func sectionTitle(count: Int) -> String { String(localized: "reviews") + ": \(count)" }
        static let writeReviewButtonTitle = String(localized: "Write a review")
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProductReviewsScreen(viewModel: .mockData)
    }
    .environmentObject(Navigation())
}
