//
//  LikeIcon.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct LikeIcon: View {

    @Binding var isSelected: Bool
    var didTapIcon: CHMVoidBlock? = nil

    var body: some View {
        ZStack {
            Circle()
                .fill(CHMColor<BackgroundPalette>.bgFavoriteIcon.color)

            Button {
                isSelected.toggle()
                didTapIcon?()
            } label: {
                if isSelected {
                    Image.favoritePressed
                } else {
                    Image.favoriteBorder
                }
            }
        }
        .frame(width: 36, height: 36)
        .shadow(color: CHMColor<ShadowPalette>.favoriteSeletected.color, radius: 10)
    }
}

#Preview {
    VStack {
        LikeIcon(isSelected: .constant(true))
        LikeIcon(isSelected: .constant(false))
    }
}
