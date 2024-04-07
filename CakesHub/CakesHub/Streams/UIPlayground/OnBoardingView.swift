//
//  OnBoardingView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 05.04.2024.
//

import SwiftUI

struct OnBoardingView: View {

    var image: Image
    var title: String
    var backAction: CHMVoidBlock
    @AppStorage(CreateProductViewModel.Keys.currentPage) var currentPage = 1

    var body: some View {
        VStack(spacing: 20) {
            NavigationBarView

            Spacer(minLength: 0)
            
            Text("Введите название торта:")
//            Text(title)
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundStyle(Constants.textColor)
//                .padding(.top)

            Spacer(minLength: 100)
        }
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
    }
}

private extension OnBoardingView {

    var NavigationBarView: some View {
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
    }
}

// MARK: - Preview

#Preview {
    OnBoardingView(image: Image(.bestGirl),
                   title: "Step 1",
                   backAction: {})
}

// MARK: - Constants

private extension OnBoardingView {

    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let iconColor = CHMColor<IconPalette>.iconRed.color
    }
}
