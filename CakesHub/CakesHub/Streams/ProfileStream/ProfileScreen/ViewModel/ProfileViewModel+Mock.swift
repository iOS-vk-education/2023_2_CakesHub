//
//  ProfileViewModel+Mock.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 26.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG
extension ProfileViewModel: Mockable {

    static let mockData: ProfileViewModel = ProfileViewModel(user: .mockData)
}
#endif
