//
//  NotificationDetailSubiew.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

extension NotificationDetailView {
    var customer: FBUserModel? { viewModel.data.customer }
    var seller: FBUserModel? { viewModel.data.seller }
    var product: FBProductModel? { viewModel.data.product }
    var notification: FBNotification { viewModel.data.notification }

    var MainView: some View {
        List {
            UsersSectionBlock

            ProductSectionBlock

            NotificationContentSectionBlock

            DeliveryAddressView
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(Constants.navigationTitle)
        .background(Constants.bgColor)
    }

    @ViewBuilder
    var UsersSectionBlock: some View {
        if let customer {
            CustomerOrSellerCell(
                sectionTitle: Constants.customerSectionTitle,
                rowTitle: customer.nickname,
                action: didTapCustomerInfo
            )
        } else if let seller {
            CustomerOrSellerCell(
                sectionTitle: Constants.sellerSectionTitle,
                rowTitle: seller.nickname,
                action: didTapSellerInfo
            )
        } else {
            LoadingView
        }
    }

    func CustomerOrSellerCell(
        sectionTitle: String,
        rowTitle: String,
        action: @escaping CHMVoidBlock
    ) -> some View {
        Section(sectionTitle) {
            Button(action: action, label: {
                TextChevronCell(title: rowTitle)
            })
        }
        .listRowBackground(Constants.rowColor)
    }

    func TextChevronCell(title: String) -> some View {
        HStack {
            Text(title)
                .style(16, .semibold, Constants.textPrimaryColor)

            Spacer()

            Image(systemName: Constants.chevronImg)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(edge: 12)
                .foregroundStyle(Constants.chevronColor)
                .bold()
        }
    }

    @ViewBuilder
    var ProductSectionBlock: some View {
        if let product {
            Section {
                CHMProductDescriptionView(
                    configuration: .basic(
                        title: product.productName,
                        price: "$\(product.price)",
                        discountedPrice: {
                            if let price = product.discountedPrice {
                                return "$\(price)"
                            }
                            return nil
                        }(),
                        subtitle: product.seller.nickname,
                        description: .clear,
                        innerHPadding: .zero,
                        starsConfiguration: .basic(kind: .five, feedbackCount: 12)
                    )
                )
                .padding()
            } header: {
                Text(Constants.productSectionTitle)
                    .padding(.leading, 20)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Constants.rowColor)
        } else {
            LoadingView
        }
    }

    var NotificationContentSectionBlock: some View {
        Section(Constants.notificationSectionTitle) {
            Group {
                Text(Constants.orderDate + ": \(notification.date.toCorrectDate)")
                    .style(14, .semibold, Constants.textWildColor)

                Text("ID: \(notification.id)")
                    .style(11, .semibold, Constants.textSecondaryColor)

                Text(notification.title)
                    .style(18, .semibold, Constants.textPrimaryColor)

                if let message = notification.message {
                    Text(message)
                        .style(14, .regular, Constants.textDescription)
                }
            }
            .listRowBackground(Constants.rowColor)
        }
    }

    var DeliveryAddressView: some View {
        Section(Constants.addressSectionTitle) {
            if let address = viewModel.data.deliveryAddress {
                Text(address)
                    .style(14, .regular, Constants.textDescription)
                    .listRowBackground(Constants.rowColor)
            } else {
                ContentUnavailableView(
                    Constants.notFoundTitle,
                    systemImage: Constants.photoImg
                )
                .listRowBackground(Constants.rowColor)
            }
        }
    }

    var LoadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Constants.rowColor)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NotificationDetailView(viewModel: .mockData)
    }
    .environmentObject(Navigation())
    .environmentObject(RootViewModel.mockData)
    .modelContainer(Preview(SDUserModel.self).container)
}

// MARK: - Constants

private extension NotificationDetailView {

    enum Constants {
        static let textPrimaryColor: Color = CHMColor<TextPalette>.textPrimary.color
        static let textWildColor: Color = CHMColor<TextPalette>.textWild.color
        static let textSecondaryColor: Color = CHMColor<TextPalette>.textSecondary.color
        static let textDescription: Color = CHMColor<TextPalette>.textDescription.color
        static let bgColor: Color = CHMColor<BackgroundPalette>.bgMainColor.color
        static let rowColor: Color = CHMColor<BackgroundPalette>.bgCommentView.color
        static let chevronColor: Color = CHMColor<IconPalette>.iconGray.color
        static let navigationTitle = String(localized: "Order")
        static let customerSectionTitle = String(localized: "Customer")
        static let sellerSectionTitle = String(localized: "Seller")
        static let productSectionTitle = String(localized: "Product")
        static let addressSectionTitle = String(localized: "Delivery address")
        static let notificationSectionTitle = String(localized: "Notification content")
        static let orderDate = String(localized: "Order date")
        static let notFoundTitle = String(localized: "User address not found")
        static let chevronImg = "chevron.right"
        static let photoImg = "photo"
    }
}
