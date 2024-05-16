//
//  ImageProvider.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 28.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

protocol ImageProviderProtocol {
    func fetchThumbnail(url: URL?) async throws -> UIImage
}

// MARK: - ImageProvider

final class ImageProvider {

    static let shared = ImageProvider()
    private let fileManager = FileManagerImageHash.shared
    private let imageCache = NSCache<NSString, UIImage>()

    private init() {}
}

// MARK: - ImageProviderProtocol

extension ImageProvider: ImageProviderProtocol {

    func fetchThumbnail(url: URL?) async throws -> UIImage {
        guard let url else { throw APIError.incorrectlyURL }

        // Проверяем наличие картинки в кэше или в fileManager
        if let uiImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return uiImage
        } else if let uiImage = fileManager.getImage(key: url.absoluteString) {
            return uiImage
        }

        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let uiImage = UIImage(data: data) else { throw APIError.responseIsNil }
        imageCache.setObject(uiImage, forKey: url.absoluteString as NSString)

        // Сохраняем в fileManager
        fileManager.saveImage(uiImage: uiImage, for: url.absoluteString)

        return uiImage
    }
}
