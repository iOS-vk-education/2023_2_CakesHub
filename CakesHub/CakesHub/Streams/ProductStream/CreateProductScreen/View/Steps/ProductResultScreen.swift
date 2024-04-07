//
//  ProductResultScreen.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.04.2024.
//

import SwiftUI

struct ProductResultScreen: View {
    @EnvironmentObject var viewModel: CreateProductViewModel
    @EnvironmentObject var rootViewModel: RootViewModel
    var backAction: CHMVoidBlock?

    var body: some View {
        ScrollView {
            ImagesBlock

            CHMProductDescriptionView(
                configuration: .basic(
                    title: viewModel.productName,
                    price: "$\(viewModel.productPrice)",
                    subtitle: rootViewModel.currentUser.name,
                    description: viewModel.productDescription,
                    starsConfiguration: .basic(kind: .zero, feedbackCount: 0)
                )
            )
            .padding(.bottom, 150)
        }
        .scrollIndicators(.hidden)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .overlay(alignment: .topLeading) {
            BackButton.padding(.leading)
        }
    }
}

// MARK: - UI Subviews

private extension ProductResultScreen {

    var ImagesBlock: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(viewModel.productImages, id: \.self) { data in
                        if let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 275, height: 413)
                                .clipped()
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    var BackButton: some View {
        Button {
            backAction?()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(CHMColor<IconPalette>.iconRed.color)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.black.opacity(0.4), in: .rect(cornerRadius: 10))
        }
    }
}

// MARK: - Preview

#Preview {
    return ProductResultScreen()
        .environmentObject(CreateProductViewModel())
        .environmentObject(RootViewModel(currentUser: .king))
}
