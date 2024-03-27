//
//  MKRImageView.swift
//  MKRDesignSystem
//
//  Created by Dmitriy Permyakov on 31.12.2023.
//

import SwiftUI

struct MKRImageView: View {

    let configuration: Configuration

    var body: some View {
        if configuration.isShimmering {
            ImageShimmeringView
        } else {
            ImageView
        }
    }
}

private extension MKRImageView {

    @ViewBuilder
    var ImageView: some View {
        switch configuration.kind {
        case let .url(url):
            if let url {
                AsyncImage(url: url) { image in
                    image
                        .imageConfiguaration(for: configuration)

                } placeholder: {
                    ImageShimmeringView
                }
            } else {
                PlaceholderView
            }

        case let .uiImage(uiImage):
            if let uiImage {
                Image(uiImage: uiImage)
                    .imageConfiguaration(for: configuration)
            } else {
                PlaceholderView
            }

        case .clear:
            EmptyView()
        }
    }

    var ImageShimmeringView: some View {
        ShimmeringView()
            .frame(
                width: configuration.imageSize.width,
                height: configuration.imageSize.height
            )
            .clippedShape(configuration.imageShape)
    }

    var PlaceholderView: some View {
        Rectangle()
            .fill(.pink)
            .frame(
                width: configuration.imageSize.width,
                height: configuration.imageSize.height
            )
            .clippedShape(configuration.imageShape)
    }
}

// MARK: - Image Configuration

private extension Image {

    func imageConfiguaration(for configuration: MKRImageView.Configuration) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: configuration.contentMode)
            .frame(
                width: configuration.imageSize.width,
                height: configuration.imageSize.height
            )
            .clipped()
            .clippedShape(configuration.imageShape)
    }
}

// MARK: - Preview

#Preview {
    MKRImageView(
        configuration: .basic(
            kind: .url(.mockCake1),
            imageSize: CGSize(width: 200, height: 200),
            imageShape: .roundedRectangle(20)
        )
    )
}

private extension View {

    func clippedShape(_ shape: MKRImageView.Configuration.ImageShape) -> some View {
        switch shape {
        case .capsule:
            return AnyView(self.clipShape(Circle()))
        case .rectangle:
            return AnyView(self.clipShape(Rectangle()))
        case let .roundedRectangle(cornerRadius):
            return AnyView(self.clipShape(RoundedRectangle(cornerRadius: cornerRadius)))
        }
    }
}
