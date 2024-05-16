//
//  UserLocationSubiew.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI
import MapKit

extension UserLocationView {

    var MainView: some View {
        Map(
            position: $viewModel.uiProperties.camera,
            selection: $viewModel.uiProperties.mapSelection
        ) {
            Marker("МГТУ", systemImage: "building", coordinate: viewModel.data.towel)
                .tint(.cyan)

            if let coordinates = viewModel.data.manager.userLocation {
                Marker("Me", systemImage: "person.fill", coordinate: coordinates)
                    .tint(.black)
            }

            ForEach(viewModel.uiProperties.results, id: \.self) { item in
                let placemark = item.placemark
                Marker(placemark.name ?? .clear, coordinate: placemark.coordinate)
            }
        }
        .mapStyle(.imagery)
        .overlay(alignment: .top) {
            HeaderBlock
        }
        .overlay(alignment: .topLeading) {
            BackButtonView
        }
        .onSubmit(of: .text) {
            viewModel.searchPlace()
        }
        .onChange(of: viewModel.uiProperties.mapSelection) { _, newValue in
            viewModel.scrollToCurrentLocation(coordinate: newValue?.placemark.coordinate)
            viewModel.uiProperties.showDetails = !newValue.isNil
        }
        .sheet(isPresented: $viewModel.uiProperties.showDetails) {
            LocationDetailsView(
                mapSelection: $viewModel.uiProperties.mapSelection,
                show: $viewModel.uiProperties.showDetails,
                action: viewModel.didSelectAddress
            )
            .presentationDetents([.height(Constants.sheetHeight)])
            .presentationBackgroundInteraction(
                .enabled(upThrough: .height(Constants.sheetHeight))
            )
            .presentationCornerRadius(12)
            .presentationBackground(.ultraThinMaterial)
        }
    }

    var HeaderBlock: some View {
        HStack {
            TextField(
                Constants.textFieldPlaceholder,
                text: $viewModel.uiProperties.textInput
            )
            .font(.subheadline)
            .padding(12)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
            .shadow(radius: 10)

            Button(action: {
                viewModel.scrollToCurrentLocation(coordinate: locationManager.userLocation)
            }, label: {
                Image(systemName: Constants.locationImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(edge: 20)
                    .foregroundStyle(.white)
            })
            .padding(12)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }

    var BackButtonView: some View {
        Button(action: viewModel.didTapBackButton, label: {
            Image(systemName: Constants.backButtonImg)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(edge: 20)
                .bold()
                .foregroundStyle(.white)
                .padding(.leading)
        })
    }
}

// MARK: - Preview

#Preview {
    UserLocationView()
        .environmentObject(Navigation())
}

// MARK: - Constants

private extension UserLocationView {

    enum Constants {
        static let sheetHeight: CGFloat = 340
        static let textFieldPlaceholder = "Поиск"
        static let locationImg = "location.fill"
        static let backButtonImg = "chevron.left"
    }
}
