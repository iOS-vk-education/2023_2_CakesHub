//
//  CHMChatCell+Preview.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct CHMChatCellPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            CHMChatCell(
                configuration: .basic(
                    imageKind: .uiImage(.cake),
                    title: "Dmitriy Permyakov",
                    subtitle: "Hello, VK! It is CakesHub application",
                    time: "02:10"
                )
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .previewDisplayName("Basic")
        }
    }
}
