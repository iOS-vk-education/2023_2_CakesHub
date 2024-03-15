//
//  CakeService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 27.12.2023.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI

// MARK: - CakeServiceProtocol

protocol CakeServiceProtocol {
    func getCakesList() async throws -> [ProductRequest]
    func createCake(cake: ProductRequest, completion: @escaping (Error?) -> Void)
}

// MARK: - CakeService

final class CakeService {

    static var shared = CakeService()
    private let storage = Storage.storage()

    private init() {}
}

// MARK: - Methods

extension CakeService: CakeServiceProtocol {

    /// Getting a list of cakes
    /// - Parameter completion: plenty of cakes
    func getCakesList() async throws -> [ProductRequest] {
        let snapshot = try await FirestoreCollections.products.collection.getDocuments()
        return snapshot.documents.compactMap {
            var product = ProductRequest(dictionary: $0.data())
            product?.documentID = $0.documentID
            return product
        }
    }

    /// Cake creation
    /// - Parameters:
    ///   - cake: info of the new cake
    ///   - completion: creation result
    func createCake(cake: ProductRequest, completion: @escaping (Error?) -> Void) {
        let dispatchGroup = DispatchGroup()

        var images: [String] = []
        switch cake.images {
        case let .images(uiImages):
            uiImages.forEach { image in
                dispatchGroup.enter()
                createImage(
                    image: image,
                    directoryName: "cake/\(cake.seller.name)/\(cake.productName)",
                    imageName: generateUniqueFileName(userID: cake.seller.name)
                ) { result in
                    switch result {
                    case let .success(url):
                        images.append(url)
                        dispatchGroup.leave()
                    case let .failure(error):
                        Logger.log(kind: .error, message: error)
                        dispatchGroup.leave()
                    }
                }
            }
        case let .url(urls):
            images = urls.toStringArray
        default:
            break
        }
        
        dispatchGroup.notify(queue: .main) {
            var firebaseCakeDocument = cake
            firebaseCakeDocument.images = .strings(images)
            let document = firebaseCakeDocument.dictionaryRepresentation
            FirestoreCollections.products.collection.addDocument(
                data: document,
                completion: completion
            )
        }
    }

    /// Image creation
    /// - Parameters:
    ///   - image: image
    ///   - directoryName: name of directory
    ///   - imageName: image name
    ///   - completion: image url
    private func createImage(
        image: UIImage?,
        directoryName: String,
        imageName: String,
        completion: @escaping CHMResultBlock<String, APIError>
    ) {
        guard let image else {
            completion(.failure(.badParameters))
            return
        }
        let storageRef = storage.reference().child("images/\(directoryName)/\(imageName).jpg")
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            completion(.failure(.badParameters))
            return
        }
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error {
                asyncMain { completion(.failure(.error(error))) }
                return
            }
            guard !metadata.isNil else {
                asyncMain { completion(.failure(.dataIsNil)) }
                return
            }

            storageRef.downloadURL { url, error in
                if let error {
                    asyncMain { completion(.failure(.error(error))) }
                    return
                }

                if let imageUrl = url?.absoluteString {
                    asyncMain { completion(.success(imageUrl)) }
                }
            }
        }
    }
}

// MARK: - Helper

/// Generation unique name for cake image
/// - Parameter userID: seller uid
/// - Returns: file name
private func generateUniqueFileName(userID: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd_HHmmssSSS"

    let currentDateTime = Date()
    let formattedDate = dateFormatter.string(from: currentDateTime)

    let uniqueFileName = "photo_\(userID)_\(formattedDate)"

    return uniqueFileName
}
