//
//  ImageProvider.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 28.03.2024.
//

import UIKit

final class ImageProvider {

    static let shared = ImageProvider()

    private let imageCache = NSCache<NSString, UIImage>()

    private init() {}

    func fetchThumbnail(url: URL?) async throws -> UIImage {
        guard let url else { throw APIError.incorrectlyURL }
        if let uiImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return uiImage
        }

        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let uiImage = UIImage(data: data) else { throw APIError.responseIsNil }
        imageCache.setObject(uiImage, forKey: url.absoluteString as NSString)
        return uiImage
    }
}
