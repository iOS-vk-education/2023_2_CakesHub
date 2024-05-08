//
//  CHMChatCell+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension CHMChatCell.Configuration {

    /// Basic configuration
    static let clear = CHMChatCell.Configuration()

    /// Basic configuration
    /// - Parameters:
    ///   - imageKind: image kind
    ///   - title: user name
    ///   - subtitle: last chat message
    ///   - time: time of last chat message
    /// - Returns: configuration of the view
    static func basic(
        imageKind: ImageKind,
        title: String,
        subtitle: String,
        time: String
    ) -> CHMChatCell.Configuration {
        modify(.clear) {
            $0.imageConfiguration = .imageConfiguration(imageKind)
            $0.title = title
            $0.subtitle = subtitle
            $0.time = time
        }
    }
}

// MARK: - MKRImageView Configuration

private extension MKRImageView.Configuration {

    static func imageConfiguration(_ kind: ImageKind) -> MKRImageView.Configuration {
        .basic(
            kind: kind,
            imageShape: .capsule
        )
    }
}
