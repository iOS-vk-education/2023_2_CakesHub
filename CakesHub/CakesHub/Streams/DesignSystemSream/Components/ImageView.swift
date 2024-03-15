//
//  ImageView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 16.02.2024.
//

import SwiftUI

struct ImageView: View {
    var body: some View {
        AsyncImage(url: .mockLoadingUrl) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
        } placeholder: {
            ShimmeringView()
        }

    }
}

struct Product: View {

    var body: some View {
        VStack {
            ImageView()
//                .frame(edge: 200)
//                .clipped()
//                .clipShape(.rect(cornerRadius: 25))

            Text("Text")
                .font(.title)
                .bold()
        }
    }
}

#Preview {
    Product()
        .frame(width: 200, height: 300)
}
