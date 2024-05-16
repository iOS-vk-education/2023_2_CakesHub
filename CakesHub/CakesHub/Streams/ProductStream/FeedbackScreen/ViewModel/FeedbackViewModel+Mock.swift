//
//  FeedbackViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11.05.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import Foundation

#if DEBUG
extension FeedbackViewModel: Mockable {

    static let mockData = FeedbackViewModel(
        data: ScreenData(
            productID: "1"
        )
    )
}
#endif
