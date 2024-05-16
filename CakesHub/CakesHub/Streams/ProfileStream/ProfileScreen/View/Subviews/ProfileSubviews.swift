//
//  ProfileSubviews.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 03.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension ProfileScreen {

    var MainView: some View {
        ScrollView {
            VStack {
                ImageBlockView

                ButtonsBlockView

                ProductsBlockView
                    .padding(.top)
            }
        }
        .ignoresSafeArea()
        .background(Constants.bgColor)
    }

    var ButtonsBlockView: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            HStack {
                if rootViewModel.currentUser.uid == viewModel.user.id {
                    MessageButton(title: Constants.createProductTitle,
                                  imgString: Constants.createProductImg,
                                  action: didTapCreateProduct)

                    Cbutton(iconname: Constants.gearButtonImg, action: didTapOpenSettings)
                    Cbutton(iconname: Constants.notificationImg, action: didTapOpenNotifications)
                } else {
                    MessageButton(title: Constants.writeMessageTitle,
                                  imgString: Constants.writeMessageImg,
                                  action: didTapOpenMessageScreen)
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: max(60 - minY, 0))
        }
        .offset(y: -36)
        .zIndex(1)

    }

    @ViewBuilder
    var ImageBlockView: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let iscrolling = minY > 0
            VStack {
                MKRImageView(
                    configuration: .basic(
                        kind: viewModel.user.userHeaderImage,
                        imageShape: .rectangle
                    )
                )
                .frame(
                    width: geo.size.width,
                    height: iscrolling ? 280 + minY : 280
                )
                .offset(y: iscrolling ? -minY : 0)
                .blur(radius: iscrolling ? 0 + minY / 60 : 0)
                .scaleEffect(iscrolling ? 1 + minY / 2000 : 1)
                .overlay(alignment: .bottom) {
                    ZStack {
                        MKRImageView(
                            configuration: .basic(
                                kind: viewModel.user.userImage,
                                imageShape: .capsule
                            )
                        )
                        .frame(width: 110, height: 110)

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

    var ProductsBlockView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(viewModel.user.products) { product in
                CHMNewProductCard(
                    configuration: .basic(
                        imageKind: product.images.first?.kind ?? .clear,
                        imageHeight: 200,
                        productText: .init(
                            seller: product.seller.name,
                            productName: product.productName,
                            productPrice: product.price
                        ),
                        productButtonConfiguration: .basic(
                            kind: .favorite(isSelected: product.isFavorite)
                        ),
                        starsViewConfiguration: .basic(
                            kind: .init(rawValue: product.starsCount) ?? .zero,
                            feedbackCount: product.reviewInfo.feedbackCount
                        )
                    )
                ) { isSelected in
                    didTapProductLikeButton(for: product.id, isSelected: isSelected)
                }
                .onTapGesture {
                    didTapProductCard(product: product)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 150)
    }
}

fileprivate struct MessageButton: View {
    var title: String
    var imgString: String
    var action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Label(title, systemImage: imgString)
                .foregroundStyle(CHMColor<TextPalette>.textPrimary.color)
                .font(.callout)
                .bold()
                .foregroundStyle(.black)
                .frame(width: 240, height: 45)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
        })
    }
}

fileprivate struct Cbutton: View {
    let iconname: UIImage?
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: iconname ?? UIImage())
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(CHMColor<IconPalette>.iconSecondary.color)
                .frame(edge: 23)
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
        static let gearButtonImg = UIImage(systemName: "gear")
        static let notificationImg = UIImage(systemName: "location.north.circle")
        static let createProductTitle = "Создать товар"
        static let createProductImg = "plus.circle"
        static let writeMessageTitle = "Cообщение"
        static let writeMessageImg = "message"
    }
}

// MARK: - Preview

#Preview {
    ProfileScreen(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel(currentUser: .poly))
}

#Preview {
    ProfileScreen(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel(currentUser: .king))
}
