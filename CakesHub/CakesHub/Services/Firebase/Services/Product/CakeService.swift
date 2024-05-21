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
    func deleteUserProducts(sellerID: String) async throws
    func deleteProduct(by id: String) async throws
    func sendFeedback(productID: String, text feedbackText: String, count countFilledStar: Int, username: String) async throws -> FBProductModel
}

// MARK: - CakeService

final class CakeService {

    static let shared: CakeServiceProtocol = CakeService()
    private let storage = Storage.storage()
    private let firestore = Firestore.firestore()
    private let userService: UserServiceProtocol = UserService.shared
    private let collection = FirestoreCollections.products.rawValue

    private init() {}
}

// MARK: - Methods

extension CakeService: CakeServiceProtocol {

    /// Getting a list of cakes
    func getCakesList() async throws -> [FBProductModel] {
        let snapshot = try await firestore.collection(collection).getDocuments()

        let correctProductModels = await withThrowingTaskGroup(of: FBProductModel?.self, returning: [FBProductModel].self) { taskGroup in
            for productSnapshot in snapshot.documents {
                taskGroup.addTask {
                    try? await self.converToCorrectFBProductModel(productDict: productSnapshot.data())
                }
            }

            var products: [FBProductModel] = []
            while let correctProductModel = try? await taskGroup.next() {
                if let correctProductModel {
                    products.append(correctProductModel)
                }
            }
            return products
        }

        return correctProductModels
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
                    directoryName: "cakes",
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
            let productDocument = self.getProductDict(product: firebaseCakeDocument)

            self.firestore.collection(self.collection).document(cake.documentID).setData(
                productDocument,
                completion: completion
            )
        }
    }

    /// Delete product by id
    func deleteProduct(by id: String) async throws {
        try await firestore.collection(collection).document(id).delete()
    }

    func sendFeedback(
        productID: String,
        text feedbackText: String,
        count countFilledStar: Int,
        username: String
    ) async throws -> FBProductModel {
        // Получаем старую информацию о продукте
        let docomuntRef = firestore.collection(collection).document(productID)
        let snapshot = try await docomuntRef.getDocument()
        
        guard let productDict = snapshot.data() else {
            throw APIError.responseIsNil
        }
        var fbProduct = try await converToCorrectFBProductModel(productDict: productDict)

        // Добавляем комментарий, если имеется текст
        if !feedbackText.isEmpty {
            let newComment = FBProductModel.FBCommentInfoModel(
                id: UUID().uuidString,
                userName: username,
                date: Date().description,
                description: feedbackText,
                countFillStars: countFilledStar
            )
            fbProduct.reviewInfo.comments.append(newComment)
            fbProduct.reviewInfo.countOfComments += 1
        }
        fbProduct.reviewInfo.feedbackCount += 1

        // Обновляем рейтинг
        switch countFilledStar {
        case 1:
            fbProduct.reviewInfo.countOneStars += 1
        case 2:
            fbProduct.reviewInfo.countTwoStars += 1
        case 3:
            fbProduct.reviewInfo.countThreeStars += 1
        case 4:
            fbProduct.reviewInfo.countFourStars += 1
        case 5:
            fbProduct.reviewInfo.countFiveStars += 1
        default:
            break
        }

        let fbProductDict = converToCorrectToCorrectDict(product: fbProduct)
        guard let newComments = fbProductDict["reviewInfo"] else {
            throw APIError.innerError
        }

        try await firestore.collection(collection).document(productID).updateData([
            "reviewInfo": newComments
        ])
        
        return fbProduct
    }
    
    /// Delete all user products
    func deleteUserProducts(sellerID: String) async throws {
        let query = firestore.collection(collection).whereField("sellerID", isEqualTo: sellerID)
        let snapshot = try await query.getDocuments()
        let batch = firestore.batch()

        for document in snapshot.documents {
            batch.deleteDocument(document.reference)
        }

        try await batch.commit()
    }
}

// MARK: - Private Methods

private extension CakeService {

    /// Создание изображений
    func createImage(
        image: UIImage?,
        directoryName: String,
        imageName: String,
        completion: @escaping CHMResultBlock<String, APIError>
    ) {
        guard let image else {
            completion(.failure(.badParameters))
            return
        }
        let storageRef = storage.reference().child("\(directoryName)/\(imageName).jpg")
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
    
    /// Конвертируем в словарь с подменой seller на sellerID
    func getProductDict(product: FBProductModel) -> [String: Any] {
        // Маппим структуру в словарь
        var productDict = product.dictionaryRepresentation
        // Заменяем структуру продовца на его uid
        if !productDict.removeValue(forKey: "seller").isNil {
            productDict["sellerID"] = product.seller.uid
        }
        return productDict
    }
    
    /// Конвертируем снэпшот в модель продукта с подменной sellerID в seller
    func converToCorrectFBProductModel(productDict: [String: Any]) async throws -> FBProductModel {
        var productDictCopy = productDict
        guard let sellerID = productDict["sellerID"] as? String else {
            throw APIError.badParameters
        }
        let fbUser = try await userService.getUserInfo(uid: sellerID)
        productDictCopy["seller"] = fbUser.dictionaryRepresentation
        guard let productModel = FBProductModel(dictionary: productDictCopy) else {
            throw APIError.dataIsNil
        }
        return productModel
    }

    func converToCorrectToCorrectDict(product: FBProductModel) -> [String: Any] {
        var dict = product.dictionaryRepresentation
        dict["sellerID"] = product.seller.uid
        return dict
    }
}

// MARK: - Helper

/// Generation unique name for cake image
/// - Parameter userID: seller uid
/// - Returns: file name
private func generateUniqueFileName(userID: String) -> String {
    let uniqueFileName = "\(userID)_\(UUID().uuidString)"
    return uniqueFileName
}
