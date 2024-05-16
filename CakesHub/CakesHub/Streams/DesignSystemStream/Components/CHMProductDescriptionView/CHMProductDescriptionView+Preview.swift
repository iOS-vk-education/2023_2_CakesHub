//
//  CHMProductDescriptionView+Preview.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 26.01.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct CHMProductDescriptionViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            CHMProductDescriptionView(
                configuration: .basic(
                    title: "H&M",
                    price: "$19.99", 
                    discountedPrice: "$12.22",
                    subtitle: "Short black dress",
                    description: """
                    Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.
                    """,
                    starsConfiguration: .basic(kind: .five, feedbackCount: 10)
                )
            )
            .previewDisplayName("Basic")
        }
    }
}
