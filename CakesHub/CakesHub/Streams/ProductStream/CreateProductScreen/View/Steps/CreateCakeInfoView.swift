//
//  CreateCakeInfoView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.04.2024.
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
                    limit: 40,
                    tint: CHMColor<TextPalette>.textPrimary.color,
                    autoResizes: false,
                    borderConfig: .init(radius: Constants.cornderRadius)
                ),
                hint: "Название торта",
                value: $cakeName
            ) {
                focusedField = .description
            }
            .fixedSize(horizontal: false, vertical: true)
            .focused($focusedField, equals: .name)

            LimitedTextField(
                config: .init(
                    limit: 900,
                    tint: CHMColor<TextPalette>.textPrimary.color,
                    autoResizes: false,
                    borderConfig: .init(radius: Constants.cornderRadius)
                ),
                hint: "Напишите описание товара",
                value: $cakeDescription
            )
            .frame(minHeight: 200, maxHeight: 280)
            .fixedSize(horizontal: false, vertical: true)
            .focused($focusedField, equals: .description)

            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button("Закрыть") {
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
    }
}

// MARK: - UI Subviews

private extension CreateCakeInfoView {

    var PriceBlockView: some View {
        HStack(alignment: .bottom, spacing: 20) {
            TextField("Цена, $", text: $cakePrice)
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
                Text("* Необязательное поле")
                    .style(11, .regular, CHMColor<TextPalette>.textSecondary.color)

                TextField("Цена со скидкой", text: $cakeDiscountedPrice)
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
}

// MARK: - Preview

#Preview {
    CreateCakeInfoView(
        cakeName: .constant(""),
        cakeDescription: .constant(""),
        cakePrice: .constant(""),
        cakeDiscountedPrice: .constant("")
    )
}

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(CreateProductViewModel())
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension CreateCakeInfoView {

    enum Constants {
        static let cornderRadius: CGFloat = 8
        static let logoImage = Image(.cakeLogo)
        static let logoColor = CHMColor<IconPalette>.iconRed.color.gradient
    }
}
