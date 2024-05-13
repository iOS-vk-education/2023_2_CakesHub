//
//  UserLocationViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Observation
import SwiftUI
import MapKit

protocol UserLocationViewModelProtocol: AnyObject {
    // MARK: Network
    func fetchMapItems() async throws -> [MKMapItem]
    // MARK: Actions
    func searchPlace()
    func scrollToCurrentLocation(coordinate: CLLocationCoordinate2D?)
    func didTapBackButton()
    func didSelectAddress(mapItem: MKMapItem?)
    // MARK: Reducers
    func setNavigation(nav: Navigation)
}

// MARK: - UserLocationViewModel

@Observable
final class UserLocationViewModel: ViewModelProtocol, UserLocationViewModelProtocol {
    var uiProperties: UIProperties
    private(set) var data: ScreenData
    private var reducers: Reducers

    init(
        uiProperties: UIProperties = .clear,
        data: ScreenData = .clear,
        reducers: Reducers = .clear
    ) {
        self.uiProperties = uiProperties
        self.data = data
        self.reducers = reducers
    }
}

// MARK: - Network

extension UserLocationViewModel {

    func fetchMapItems() async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = uiProperties.textInput
        let results = try await MKLocalSearch(request: request).start()
        return results.mapItems
    }
}

// MARK: - Actions

extension UserLocationViewModel {
    
    /// Пользователь ввёл данные `поиска`
    func searchPlace() {
        uiProperties.textInput = .clear
        Task {
            let results = (try? await fetchMapItems()) ?? []
            uiProperties.results = results
            guard let center = results.first else { return }
            withAnimation {
                uiProperties.camera = .region(
                    .init(
                        center: center.placemark.coordinate,
                        latitudinalMeters: 200,
                        longitudinalMeters: 200
                    )
                )
            }
        }
    }

    /// Скролл на текущею позицию или выбранный город
    func scrollToCurrentLocation(coordinate: CLLocationCoordinate2D?) {
        let scrollToCoordinate: CLLocationCoordinate2D
        if let coordinate {
            scrollToCoordinate = coordinate
        } else {
            scrollToCoordinate = data.towel
        }

        withAnimation {
            uiProperties.camera = .region(
                .init(
                    center: scrollToCoordinate,
                    latitudinalMeters: 100,
                    longitudinalMeters: 100
                )
            )
        }
    }
    
    /// Нажата кнопка `назад`
    func didTapBackButton() {
        reducers.nav.openPreviousScreen()
    }

    /// Выбран адрес
    func didSelectAddress(mapItem: MKMapItem?) {
        // TODO: Добавить запрос в сеть на обновления адреса заказа для пользователя
        guard let title = mapItem?.placemark.title else { return }
        Logger.print("Выбрали: \(title)")
    }
}

// MARK: - Reducers

extension UserLocationViewModel {

    func setNavigation(nav: Navigation) {
        reducers.nav = nav
    }
}
