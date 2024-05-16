//
//  SettingsViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 14.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG

extension SettingsViewModel: Mockable {

    static let mockData = SettingsViewModel()
}

#endif
