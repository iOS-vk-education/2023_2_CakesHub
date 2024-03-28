//
//  ProfileViewModel+Mock.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 26.03.2024.
//

import Foundation

#if DEBUG
extension ProfileViewModel: Mockable {

    static let mockData: ProfileViewModel = ProfileViewModel(user: .mockData)
}
#endif
