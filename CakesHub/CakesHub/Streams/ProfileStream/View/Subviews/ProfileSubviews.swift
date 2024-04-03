//
//  ProfileSubviews.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 03.04.2024.
//

import SwiftUI

private extension ProfileScreen {
    
    @ViewBuilder
    var imageView: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let iscrolling = minY > 0
            VStack {
                MKRImageView(
                    configuration: .basic(
                        kind: viewModel.user.userHeaderImage,
                        imageSize: CGSize(
                            width: geo.size.width,
                            height: iscrolling ? 280 + minY : 280
                        ),
                        imageShape: .rectangle
                    )
                )
                .offset(y: iscrolling ? -minY : 0)
                .blur(radius: iscrolling ? 0 + minY / 60 : 0)
                .scaleEffect(iscrolling ? 1 + minY / 2000 : 1)
                .overlay(alignment: .bottom) {
                    ZStack {
                        MKRImageView(
                            configuration: .basic(
                                kind: viewModel.user.userImage,
                                imageSize: CGSize(width: 110, height: 110),
                                imageShape: .capsule
                            )
                        )
                        
                        Circle().stroke(lineWidth: 6)
                            .fill(Constants.bgColor)
                    }
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .offset(y: 25)
                    .offset(y: iscrolling ? -minY : 0)
                }

                Group {
                    VStack(spacing: 6) {
                        Text(viewModel.user.name.uppercased())
                            .bold()
                            .font(.title)
                        Text(viewModel.user.mail).font(.callout)
                            .foregroundStyle(Constants.userMailColor)
                            .multilineTextAlignment(.center)
                            .frame(width: geo.size.width)
                            .lineLimit(1)
                            .fixedSize()
                            .foregroundStyle(Constants.textColor)
                    }
                    .offset(y: iscrolling ? -minY : 0)
                }
                .padding(.vertical, 18)
            }
        }
        .frame(height: 400)
    }
}

fileprivate struct ProductFeedView: View {
    var user: UserModel

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(user.products) { product in
                CHMNewProductCard(
                    configuration: .basic(
                        imageKind: product.images.first?.kind ?? .clear,
                        imageSize: CGSize(width: 160, height: 184),
                        productText: .init(
                            seller: product.sellerName,
                            productName: product.productName,
                            productPrice: product.price
                        ),
                        productButtonConfiguration: .basic(
                            kind: .favorite(isSelected: product.isFavorite)
                        ),
                        starsViewConfiguration: .basic(
                            kind: .init(rawValue: product.starsCount) ?? .zero,
                            feedbackCount: product.reviewInfo.feedbackCounter
                        )
                    )
                )
                .frame(width: 148)
            }
            .padding(.horizontal, 5)
        }
    }
}

fileprivate struct Cbutton: View {
    let iconname: UIImage
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: iconname).renderingMode(.template).resizable().scaledToFill()
                .foregroundStyle(CHMColor<IconPalette>.iconSecondary.color)
                .frame(width: 23, height: 23)
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
        }
    }
}

// MARK: - Constants

private extension ProfileScreen {
    
    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
