//
//  ContentView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 22.03.2024.
//

import SwiftUI

struct ProfileScreen: View {
    
    @StateObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                imageView
                GeometryReader { geo in
                    let minY = geo.frame(in: .global).minY
                    HStack {
                        Button(action: {}, label: {
                            Label("message", systemImage: "message")
                                .foregroundStyle(Constants.textColor)
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.black)
                                .frame(width: 240, height: 45)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
                        })
                        Cbutton(iconname: .bell, action: {})
                        Cbutton(iconname: .bell, action: {})
                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: max(60 - minY, 0))
                }
                .offset(y: -36)
                .zIndex(1)
                ProductFeedView()
            }
        }
        .ignoresSafeArea()
        .background(Constants.bgColor)
    }
}

private extension ProfileScreen {
    
    @ViewBuilder
    var imageView: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let iscrolling = minY > 0
            VStack {
                MKRImageView(
                    configuration: .basic(
                        kind: viewModel.user.userImage,
                        imageSize: CGSize(width: 400, height: iscrolling ? 280 + minY : 280),
                        imageShape: .rectangle
                    )
                )
                .frame(height: iscrolling ? 280 + minY : 280)
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
                    }
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .offset(y: 25)
                    .offset(y: iscrolling ? -minY : 0)
                }
                Group {
                    VStack(spacing: 6) {
                        Text("MILANA").bold().font(.title)
                        Text("Кондитер").font(.callout)
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
        .clipped()
        .scaledToFill()
        .frame(height: 400)
        
    }
}



fileprivate struct ProductFeedView: View {
    var body: some View{
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
            ForEach(0..<25) { item in
                CHMNewProductCard(
                    configuration: .basic(
                        imageKind: .url(.mockProductCard),
                        imageSize: CGSize(width: 160, height: 184),
                        productText: .init(
                            seller: "MILANA",
                            productName: "Women's Day cake",
                            productPrice: "30$"
                        ),
                        productButtonConfiguration: .basic(kind: .favorite()),
                        starsViewConfiguration: .basic(kind: .four, feedbackCount: 20000)
                    )
                )
                .frame(width: 148)
            }
            .padding(.horizontal, 5)
        })
    }
}

struct Cbutton: View {
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
                .overlay {
                    Circle().stroke(lineWidth: 1)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .bottomLeading, endPoint: .topTrailing))
                }
        }
    }
}

// MARK: - Constants

private extension ProfileScreen {
    
    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let iconColor = CHMColor<IconPalette>.iconGray.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}


// MARK: - Preview

#Preview {
    ProfileScreen(viewModel: ProfileViewModel(user: .mockData))
}
