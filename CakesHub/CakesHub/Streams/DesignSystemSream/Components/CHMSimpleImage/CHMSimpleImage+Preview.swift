//
//  CHMSimpleImage+Preview.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct CHMSimpleImagePreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            CHMSimpleImage(
                configuration: .basic(
                    imageKind: .url(.mockCake1)
                )
            )
            .previewDisplayName("Basic")
        }
    }
}
