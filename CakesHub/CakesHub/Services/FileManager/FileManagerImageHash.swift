//
//  FileManagerImageHash.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 17.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

protocol FileManagerImageHashProtocol {
    func getImage(key: String) -> UIImage?
    func saveImage(uiImage: UIImage, for key: String)
    func deleteImage(by key: String)
}

// MARK: - FileManagerImageHash

final class FileManagerImageHash {

    static let shared = FileManagerImageHash()
    private let fileManager = FileManager.default
    private let saveQueue = DispatchQueue(label: "com.vk.FileManagerImageHash.saveImages", qos: .utility, attributes: [.concurrent])
}

// MARK: - FileManagerImageHashProtocol

extension FileManagerImageHash: FileManagerImageHashProtocol {

    func getImage(key: String) -> UIImage? {
        guard let url = path else {
            Logger.log(kind: .error, message: "file manager url is nil")
            return nil
        }
        let imageURL = url.appendingPathComponent(imageHash(with: key))
        
        guard
            fileManager.fileExists(atPath: imageURL.path(percentEncoded: true)),
            let data = try? Data(contentsOf: imageURL)
        else {
            Logger.log(kind: .error, message: "file is not found or data is nil")
            return nil
        }

        return UIImage(data: data)
    }

    func saveImage(uiImage: UIImage, for key: String) {
        guard let url = path else {
            Logger.log(kind: .error, message: "file manager url is nil")
            return
        }
        let imageURL = url.appendingPathComponent(imageHash(with: key))
        saveQueue.async {
            let data = uiImage.pngData()
            do {
                try data?.write(to: imageURL, options: [.atomic])
                Logger.log(message: "image by key: [\(key)] successfully saved!")
            } catch {
                Logger.log(kind: .error, message: error)
            }
        }
    }

    func deleteImage(by key: String) {
        guard let url = path else {
            Logger.log(kind: .error, message: "file manager url is nil")
            return
        }

        let imageURL = url.appendingPathComponent(imageHash(with: key))

        do {
            try fileManager.removeItem(atPath: imageURL.path(percentEncoded: true))
        } catch {
            Logger.log(kind: .error, message: "failed deletion of the file by key: \(key)")
        }
    }
}

// MARK: - Helpers

private extension FileManagerImageHash {

    var path: URL? {
        try? fileManager.url(for: .documentDirectory,
                             in: .userDomainMask,
                             appropriateFor: nil,
                             create: true)
    }

    func imageHash(with key: String) -> String {
        let charset = CharacterSet.alphanumerics.inverted
        return key.components(separatedBy: charset).joined()
    }
}
