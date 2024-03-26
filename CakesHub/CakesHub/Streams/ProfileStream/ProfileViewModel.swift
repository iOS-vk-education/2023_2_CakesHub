//
//  ProfileViewModel.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 25.03.2024.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: UserModel
    
    init(user: UserModel = .init()) {
        self.user = user
    }
}
                                    
