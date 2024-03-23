//
//  ProductReviewsSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.03.2024.
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
                commonCount: Constants.sectionTitle(count: viewModel.data.feedbackCounter)
            )
        )
    }

    var SectionTitle: some View {
        Text(Constants.sectionTitle(count: viewModel.data.countOfComments))
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
}

// MARK: - ReviewCell

fileprivate struct ReviewCell: View {
    @State private var animateReview = false
    @State private var reviewSize: CGFloat = .zero
    var comment: ProductReviewsModel.CommentInfo

    var body: some View {
        CHMCommentView(
            configuration: .basic(
                imageKind: .url(.mockProductCard),
                userName: comment.userName,
                date: comment.date,
                description: comment.description,
                starsConfiguration: .basic(
                    kind: .init(rawValue: comment.countFillStars) ?? .zero,
                    feedbackCount: comment.feedbackCount
                )
            )
        )
        .offset(x: animateReview ? 0 : reviewSize)
        .overlay {
            AppearanceCalculationsView
        }
    }
}

// MARK: - Helper

private extension ReviewCell {

    var AppearanceCalculationsView: some View {
        GeometryReader {
            let size = $0.size
            let minY = $0.frame(in: .global).minY
            Color.clear
                .onAppear {
                    reviewSize = size.height
                }
                .onChange(of: minY) { oldValue, newValue in
                    if newValue < size.height * 1.4 && !animateReview {
                        withAnimation(.spring(duration: 0.45)) {
                            animateReview = true
                        }
                    }
                }
        }
    }
}

// MARK: - Constants

private extension ProductReviewsScreen {

    enum Constants {
        static func sectionTitle(count: Int) -> String { "\(count) ratings" }
    }
}

// MARK: - Preview

#Preview {
    ProductReviewsScreen(
        viewModel: .init(data: .mockData),
        screenIsAppeared: .constant(true)
    )
    .environmentObject(Navigation())
}
