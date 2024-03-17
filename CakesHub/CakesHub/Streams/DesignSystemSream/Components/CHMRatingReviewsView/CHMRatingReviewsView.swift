//
//  CHMRatingReviewsView.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

/**
 Component `CHMRatingReviewsView`

 For example:
 ```swift
 let view = CHMRatingReviewsView(
     configuration: .basic(
         fiveStarRating: .basic(ration: .hundred, count: 12),
         fourStarRating: .basic(ration: .sixty, count: 5),
         threeStarRating: .basic(ration: .thirty, count: 4),
         twoStarRating: .basic(ration: .twenty, count: 2),
         oneStarRating: .basic(ration: .zero, count: 0),
         commontRating: "4.3",
         commontCount: "23 ratings"
     )
 )
 ```
*/
struct CHMRatingReviewsView: View {

    var configuration: Configuration

    var body: some View {
        HStack {
            VStack {
                Text(configuration.commontRating)
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(CHMColor<TextPalette>.textPrimary.color)

                Text(configuration.commentCount)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(CHMColor<TextPalette>.textSecondary.color)
            }

            RightBlock
                .padding(.leading, 28)
        }
    }
}

private extension CHMRatingReviewsView {

    var RightBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(configuration.counts) { counter in
                HStack {
                    HStack(spacing: 3) {
                        ForEach(0..<5-counter.id, id: \.self) { row in
                            Image.starFill
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 13)
                        }
                    }

                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(CHMColor<SeparatorPalette>.redLine.color)
                            .frame(width: geometry.size.width * counter.ration, height: 8)
                            .padding(.trailing, 100)
                            .offset(y: geometry.size.height * 0.25)
                    }

                    Spacer()

                    Text("\(counter.count)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(CHMColor<TextPalette>.textSecondary.color)
                }
                .frame(maxWidth: .infinity, maxHeight: 14, alignment: .leading)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CHMRatingReviewsView(
        configuration: .basic(
            fiveStarRating: .basic(ration: .hundred, count: 12),
            fourStarRating: .basic(ration: .sixty, count: 5),
            threeStarRating: .basic(ration: .thirty, count: 4),
            twoStarRating: .basic(ration: .twenty, count: 2),
            oneStarRating: .basic(ration: .zero, count: 0),
            commonRating: "4.3",
            commonCount: "23 ratings"
        )
    )
    .padding(.horizontal)
}
