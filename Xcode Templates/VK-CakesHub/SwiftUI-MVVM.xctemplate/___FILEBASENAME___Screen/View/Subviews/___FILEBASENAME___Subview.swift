//
//  ___VARIABLE_productName:identifier___Subiew.swift
//  CakesHub
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

extension ___VARIABLE_productName:identifier___View {

    #warning("Тут должна быть вашь вьюха")
    var MainView: some View {
        VStack {
            MKRImageView(
                configuration: .basic(
                    kind: viewModel.data.imageKind,
                    imageShape: .roundedRectangle(Constants.imageCornerRadius)
                )
            )
            .frame(width: Constants.imageSize, height: Constants.imageSize)

            Text(viewModel.data.title)
                .style(14, .semibold, Constants.textColor)
        }
    }
}

// MARK: - Preview

#warning("Удалите навигацию, если она не требуется")
#Preview {
    ___VARIABLE_productName:identifier___View(viewModel: .mockData)
        .environmentObject(Navigation())
}

// MARK: - Constants

#warning("Добавляйте сюда все необходимые константы")
private extension ___VARIABLE_productName:identifier___View {

    enum Constants {
        static let imageSize: CGFloat = 200
        static let imageCornerRadius: CGFloat = 20
        static let textColor: Color = CHMColor<TextPalette>.textPrimary.color
    }
}
