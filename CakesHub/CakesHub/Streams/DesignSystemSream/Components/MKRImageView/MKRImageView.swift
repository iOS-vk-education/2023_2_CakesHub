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
            GeometryReader { geo in
                ShimmeringView()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clippedShape(configuration.imageShape)
            }
        } else {
            ImageView
        }
    }
}

private extension MKRImageView {

    @ViewBuilder
    var ImageView: some View {
        GeometryReader { geo in
            let size = geo.size
            switch configuration.kind {
            case let .url(url):
                if let url {
                    AsyncImage(url: url) { image in
                        image
                            .imageConfiguaration(for: configuration, size: size)

                    } placeholder: {
                        ImageShimmeringView(size: size)
                    }
                } else {
                    PlaceholderView(size: size)
                }

            case let .uiImage(uiImage):
                if let uiImage {
                    Image(uiImage: uiImage)
                        .imageConfiguaration(for: configuration, size: size)
                } else {
                    PlaceholderView(size: size)
                }

            case .clear:
                EmptyView()
            }
        }
    }

    func ImageShimmeringView(size: CGSize) -> some View {
        ShimmeringView()
            .frame(width: size.width, height: size.height)
            .clippedShape(configuration.imageShape)
    }

    func PlaceholderView(size: CGSize) -> some View {
        Rectangle()
            .fill(.pink)
            .frame(width: size.width, height: size.height)
            .clippedShape(configuration.imageShape)
    }
}

// MARK: - Image Configuration

private extension Image {

    func imageConfiguaration(for configuration: MKRImageView.Configuration, size: CGSize) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: configuration.contentMode)
            .frame(
                width: size.width,
                height: size.height
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
            imageShape: .roundedRectangle(20)
        )
    )
}

#Preview {
    MKRImageView(
        configuration: .shimmering(imageShape: .roundedRectangle(20))
    )
    .frame(width: 200, height: 400)
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
