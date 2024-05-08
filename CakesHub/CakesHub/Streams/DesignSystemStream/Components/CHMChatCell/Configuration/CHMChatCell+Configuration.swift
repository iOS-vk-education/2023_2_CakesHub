//
//  CHMChatCell+Configuration.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

extension CHMChatCell {

    struct Configuration {

        /// Configuration of the image view
        var imageConfiguration: MKRImageView.Configuration = .clear

        // MARK: Properties

        /// Title text
        var title: String = .clear
        /// Subtitle text
        var subtitle: String = .clear
        /// Time text
        var time: String = .clear
    }
}
