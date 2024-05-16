//
//  CreateCakeInfoView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct CreateCakeInfoView: View {
    private enum Field: Int, CaseIterable {
        case name, price, description
    }

    @Binding var cakeName: String
    @Binding var cakeDescription: String
    @Binding var cakePrice: String
    @Binding var cakeDiscountedPrice: String
    @EnvironmentObject var viewModel: CreateProductViewModel
    @FocusState private var focusedField: Field?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Constants.logoImage
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .foregroundStyle(Constants.logoColor)
                    .padding(.bottom)

                PriceBlockView
                    .focused($focusedField, equals: .price)
                    .padding(.bottom)

                LimitedTextField(
                    config: .init(
                        limit: Constants.priceLimit,
                        tint: CHMColor<TextPalette>.textPrimary.color,
                        autoResizes: false,
                        borderConfig: .init(radius: Constants.cornderRadius)
                    ),
                    hint: Constants.procductNamePlaceholder,
                    value: $cakeName
                ) {
                    focusedField = .description
                }
                .fixedSize(horizontal: false, vertical: true)
                .focused($focusedField, equals: .name)

                LimitedTextField(
                    config: .init(
                        limit: Constants.descriptionLimit,
                        tint: CHMColor<TextPalette>.textPrimary.color,
                        autoResizes: false,
                        borderConfig: .init(radius: Constants.cornderRadius)
                    ),
                    hint: Constants.procductDescriptionPlaceholder,
                    value: $cakeDescription
                )
                .frame(minHeight: 200, maxHeight: 280)
                .fixedSize(horizontal: false, vertical: true)
                .focused($focusedField, equals: .description)

                Spacer()
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                KeyboardToolBarItems
            }
        }
    }
}

// MARK: - UI Subviews

private extension CreateCakeInfoView {

    var PriceBlockView: some View {
        HStack(alignment: .bottom, spacing: 20) {
            TextField(Constants.pricePlaceholder, text: $cakePrice)
                .keyboardType(.numberPad)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.cornderRadius)
                        .stroke(lineWidth: 0.8)
                }
                .submitLabel(.done)
                .onSubmit {
                    focusedField = .name
                }

            VStack(alignment: .leading, spacing: 5) {
                Text(Constants.discountedPriceBar)
                    .style(11, .regular, CHMColor<TextPalette>.textSecondary.color)

                TextField(Constants.discountedPricePlaceholder, text: $cakeDiscountedPrice)
                    .keyboardType(.decimalPad)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.cornderRadius)
                            .stroke(lineWidth: 0.8)
                }
            }
        }
    }

    @ViewBuilder
    var KeyboardToolBarItems: some View {
        HStack {
            Button("Close") {
                focusedField = nil
            }

            Spacer()

            Button {
                switch focusedField {
                case .price:
                    focusedField = .name
                case .name:
                    focusedField = .description
                case .description:
                    focusedField = nil
                case .none:
                    focusedField = nil
                }
            } label: {
                Image(systemName: "checkmark")
                    .foregroundStyle(CHMColor<IconPalette>.iconRed.color)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CreateCakeInfoView(
        cakeName: .constant(.clear),
        cakeDescription: .constant(.clear),
        cakePrice: .constant(.clear),
        cakeDiscountedPrice: .constant(.clear)
    )
}

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(CreateProductViewModel.mockData)
        .environmentObject(RootViewModel.mockData)
        .environmentObject(ProfileViewModel.mockData)
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension CreateCakeInfoView {

    enum Constants {
        static let cornderRadius: CGFloat = 8
        static let priceLimit = 40
        static let descriptionLimit = 900
        static let pricePlaceholder = String(localized: "Price, $")
        static let procductNamePlaceholder = String(localized: "Cake name")
        static let procductDescriptionPlaceholder = String(localized: "Write a description of the product...")
        static let discountedPriceBar = "* " + String(localized: "Optional field")
        static let discountedPricePlaceholder = String(localized: "Discounted price")
        static let logoImage = Image(.cakeLogo)
        static let logoColor = CHMColor<IconPalette>.iconRed.color.gradient
    }
}
