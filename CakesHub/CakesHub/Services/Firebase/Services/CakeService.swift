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
    func getCakesList() async throws -> [FBProductModel]
    func createCake(cake: FBProductModel, completion: @escaping (Error?) -> Void)
}

// MARK: - CakeService

final class CakeService {

    static let shared = CakeService()
    private let storage = Storage.storage()

    private init() {}
}

// MARK: - Methods

extension CakeService: CakeServiceProtocol {

    /// Getting a list of cakes
    func getCakesList() async throws -> [FBProductModel] {
        let snapshot = try await Firestore.firestore().collection(FirestoreCollections.products.rawValue).getDocuments()
        return snapshot.documents.compactMap { FBProductModel(dictionary: $0.data()) }
    }

    /// Cake creation
    func createCake(cake: FBProductModel, completion: @escaping (Error?) -> Void) {
        let dispatchGroup = DispatchGroup()

        var images: [String] = []
        switch cake.images {
        case let .images(uiImages):
            uiImages.forEach { image in
                dispatchGroup.enter()
                createImage(
                    image: image,
                    directoryName: "cake/\(cake.seller.email)/\(cake.productName)",
                    imageName: generateUniqueFileName(userID: cake.seller.uid)
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
            images = urls.compactMap { $0?.absoluteString }
        default:
            break
        }
        
        dispatchGroup.notify(queue: .main) {
            var firebaseCakeDocument = cake
            firebaseCakeDocument.images = .strings(images)
            let document = firebaseCakeDocument.dictionaryRepresentation

            Firestore.firestore().collection(FirestoreCollections.products.rawValue).document(cake.documentID).setData(
                document,
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

        let mainQueueCompletion: CHMResultBlock<String, APIError> = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error {
                mainQueueCompletion(.failure(.error(error)))
                return
            }
            guard !metadata.isNil else {
                mainQueueCompletion(.failure(.dataIsNil))
                return
            }

            storageRef.downloadURL { url, error in
                if let error {
                    mainQueueCompletion(.failure(.error(error)))
                    return
                }

                if let imageUrl = url?.absoluteString {
                    mainQueueCompletion(.success(imageUrl))
                    return
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
