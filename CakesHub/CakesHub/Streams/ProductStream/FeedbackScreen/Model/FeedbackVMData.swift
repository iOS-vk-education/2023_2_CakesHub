//
//
//  FeedbackVMData.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension FeedbackViewModel {

    struct ScreenData {
        var productID: String
        var root: RootViewModel?
        var reviewViewModel: ProductReviewsViewModel?
        var dismiss: DismissAction?
    }
}
