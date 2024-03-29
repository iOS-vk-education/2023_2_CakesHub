//
//  ProfileScreen.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 22.03.2024.
//

import SwiftUI

struct ProfileScreen: View {
    typealias ViewModel = ProfileViewModel

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var nav: Navigation

    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        MainView
            .navigationDestination(for: ViewModel.Screens.self) { screen in
                switch screen {
                case .message:
                    Text("Экран чата")
                case .notifications:
                    Text("Экран уведомлений")
                case .settings:
                    SettingsView()
                }
            }
    }
}

// MARK: - Actions

private extension ProfileScreen {

    /// Нажатие на кнопку открытия чата
    func didTapOpenMessageScreen() {
        nav.addScreen(screen: ViewModel.Screens.message)
    }

    /// Нажатие на кнопку открытия настроек
    func didTapOpenSettings() {
        nav.addScreen(screen: ViewModel.Screens.settings)
    }
    
    /// Нажатие на кнопку открытия уведомлений
    func didTapOpenNotifications() {
        nav.addScreen(screen: ViewModel.Screens.notifications)
    }
}

// MARK: UI Components

private extension ProfileScreen {

    var MainView: some View {
        ScrollView {
            VStack {
                imageView

                GeometryReader { geo in
                    let minY = geo.frame(in: .global).minY
                    HStack {
                        Button(action: didTapOpenMessageScreen, label: {
                            Label("message", systemImage: "message")
                                .foregroundStyle(Constants.textColor)
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.black)
                                .frame(width: 240, height: 45)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
                        })
                        Cbutton(iconname: UIImage(systemName: "gear"), action: didTapOpenSettings)
                        Cbutton(iconname: .bell, action: didTapOpenNotifications)
                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: max(60 - minY, 0))
                }
                .offset(y: -36)
                .zIndex(1)

                ProductFeedView(user: viewModel.user)
                    .padding(.top)
            }
        }
        .ignoresSafeArea()
        .background(Constants.bgColor)
    }

    @ViewBuilder
    var imageView: some View {
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
}

fileprivate struct ProductFeedView: View {
    var user: UserModel
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(user.products) { product in
                CHMNewProductCard(
                    configuration: .basic(
                        imageKind: product.images.first?.kind ?? .clear,
                        imageHeight: 200,
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
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 150)
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
                .scaledToFill()
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

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileScreen(viewModel: .mockData)
    }
    .environmentObject(Navigation())
}
