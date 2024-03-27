//
//  ProfileViewModel.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 25.03.2024.
//

import SwiftUI

// MARK: - ProfileViewModelProtocol

protocol ProfileViewModelProtocol: AnyObject {}

// MARK: - ProfileViewModelProtocol

final class ProfileViewModel: ObservableObject, ViewModelProtocol {
    @Published private(set) var user: UserModel
    
    init(user: UserModel = .init()) {
        self.user = user
    }
}

extension ProfileViewModel {

    enum Screens {
        case message
        case notifications
        case settings
    }
}

// MARK: - Actions

extension ProfileViewModel: ProfileViewModelProtocol {}
