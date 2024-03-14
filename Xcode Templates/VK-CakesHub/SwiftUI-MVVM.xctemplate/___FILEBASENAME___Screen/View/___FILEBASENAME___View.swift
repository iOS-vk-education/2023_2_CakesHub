//
//  ___VARIABLE_productName:identifier___View.swift
//  CakesHub
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI

struct ___VARIABLE_productName:identifier___View: View, ViewModelable {
    typealias ViewModel = ___VARIABLE_productName:identifier___ViewModel

    #warning("Удалите навигацию, если она не требуется")
    @EnvironmentObject private var nav: Navigation
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        MainView
            .onAppear(perform: onAppear)
    }
}

// MARK: - Network

private extension ___VARIABLE_productName:identifier___View {

    #warning("Тут логика при появлении экрана")
    func onAppear() {
    }
}

// MARK: - Subviews

private extension ___VARIABLE_productName:identifier___View {

    #warning("Тут должна быть вашь вьюха")
    var MainView: some View {
        VStack {
            MKRImageView(
                configuration: .basic(
                    kind: viewModel.image,
                    imageSize: CGSize(edge: .imageSize),
                    imageShape: .roundedRectangle(.imageCornerRadius)
                )
            )

            Text(viewModel.title)
                .style(14, .semibold, .textPrimary)
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
private extension CGFloat {

    static let imageSize: CGFloat = 200
    static let imageCornerRadius: CGFloat = 20
}

