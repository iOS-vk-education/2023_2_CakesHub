//
//  UserLocationViewModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Observation
import SwiftUI
import SwiftData
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
    func setReducers(nav: Navigation, root: RootViewModel, modelContext: ModelContext)
}

// MARK: - UserLocationViewModel

@Observable
final class UserLocationViewModel: ViewModelProtocol, UserLocationViewModelProtocol {
    var uiProperties: UIProperties
    private(set) var data: ScreenData
    private var reducers: Reducers
    private let userService: UserServiceProtocol

    init(
        uiProperties: UIProperties = .clear,
        data: ScreenData = .clear,
        reducers: Reducers = .clear,
        userService: UserServiceProtocol = UserService.shared
    ) {
        self.uiProperties = uiProperties
        self.data = data
        self.reducers = reducers
        self.userService = userService
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
    @MainActor
    func searchPlace() {
        Task {
            let results = (try? await fetchMapItems()) ?? []
            uiProperties.results = results
            uiProperties.textInput = .clear
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
                    latitudinalMeters: 200,
                    longitudinalMeters: 200
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
        guard let placemark = mapItem?.placemark else { return }
        let userAddress = placemark.description
        Task {
            do {
                try await userService.addUserAddress(for: reducers.root.currentUser.uid, address: userAddress)
            } catch {
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
        uiProperties.mapSelection = nil

        // Кэшируем адрес пользователя
        let userID = reducers.root.currentUser.uid
        let fetchDescriptor = FetchDescriptor<SDUserModel>(predicate: #Predicate { $0._id == userID })
        guard var sdUser = try? reducers.modelContext.fetch(fetchDescriptor).first else {
            return
        }
        sdUser._address = userAddress
        reducers.modelContext.insert(sdUser)
        do {
            try reducers.modelContext.save()
        } catch {
            Logger.log(kind: .error, message: error.localizedDescription)
        }
    }
}

// MARK: - Reducers

extension UserLocationViewModel {

    func setReducers(nav: Navigation, root: RootViewModel, modelContext: ModelContext) {
        reducers.nav = nav
        reducers.root = root
        reducers.modelContext = modelContext
    }
}
