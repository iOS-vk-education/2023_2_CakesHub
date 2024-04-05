//
//  CreateProductSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//

import SwiftUI

private let totalCount = 3
private enum Screen: String {
    case currentPage = "com.vk.currentPage.CreateProductView"
}

extension CreateProductView {

    var MainView: some View {
        ZStack {
            if currentPage == 1 {
                OnBoardingView(image: Image(uiImage: CHMImage.mockImageCake!),
                               title: "Step 1") {

                }.transition(.scale)
            } else if currentPage == 2 {
                OnBoardingView(image: Image(uiImage: CHMImage.mockImageCake2!),
                               title: "Step 2") {
                    withAnimation(.easeInOut) {
                        currentPage -= 1
                    }
                }.transition(.scale)
            } else if currentPage == 3 {
                OnBoardingView(image: Image(uiImage: CHMImage.mockImageCake3!),
                               title: "Step 3") {
                    withAnimation(.easeInOut) {
                        currentPage -= 1
                    }
                }.transition(.scale)
            }
        }
        .overlay(alignment: .bottom) {
            NextButton
                .padding(.bottom)
        }
    }

    var NextButton: some View {
        Button(action: {
            withAnimation {
                currentPage += 1
            }
        }, label: {
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 60, height: 60)
                .foregroundStyle(Constants.iconColor)
                .background(.white, in: .circle)
                .overlay {
                    CircleBlock
                        .padding(-15)
                }
        })
    }

    var CircleBlock: some View {
        ZStack {
            Circle()
                .stroke(Constants.textColor.opacity(0.04), lineWidth: 4)

            Circle()
                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalCount))
                .stroke(Constants.textColor, lineWidth: 4)
                .rotationEffect(.init(degrees: -90))
        }
    }
}

private struct OnBoardingView: View {

    var image: Image
    var title: String
    var backAction: CHMVoidBlock
    @AppStorage("com.vk.currentPage.CreateProductView") var currentPage = 1

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if currentPage == 1 {
                    Text("Hello Member!")
                        .font(.title)
                        .fontWeight(.bold)
                        .kerning(1.4)
                } else {
                    Button(action: backAction, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Constants.iconColor)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4), in: .rect(cornerRadius: 10))
                    })
                }

                Spacer()

                Button(action: {}, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }
            .foregroundStyle(Constants.textColor)
            .padding()

            Spacer(minLength: 0)

            image
                .resizable()
                .aspectRatio(contentMode: .fit)

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Constants.textColor)
                .padding(.top)

            Spacer(minLength: 100)
        }
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
    }
}

// MARK: - Preview

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension OnBoardingView {

    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let iconColor = CHMColor<IconPalette>.iconRed.color
    }
}

private extension CreateProductView {

    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let iconColor = CHMColor<IconPalette>.iconRed.color
    }
}
