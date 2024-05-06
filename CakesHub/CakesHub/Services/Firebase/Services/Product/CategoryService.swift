//
//  CategoryService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.05.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol CategoryServiceProtocol: AnyObject {
    func fetch() async throws -> [FBCateoryModel]
    func create(with category: FBCateoryModel) async throws
}

// MARK: - CategoryService

final class CategoryService {

    static let shared: CategoryServiceProtocol = CategoryService()
    private let collection = FirestoreCollections.categories.rawValue
    private let firestore = Firestore.firestore()

    private init() {}
}

// MARK: - CategoryServiceProtocol

extension CategoryService: CategoryServiceProtocol {

    func fetch() async throws -> [FBCateoryModel] {
        let snapshot = try await firestore.collection(collection).getDocuments()
        let categories = snapshot.documents.compactMap {
            FBCateoryModel(dictionary: $0.data())
        }
        return categories
    }

    func create(with category: FBCateoryModel) async throws {
        let documentRef = firestore.collection(collection).document(category.id)
        var categoryDictionary = category.dictionaryRepresentation
        categoryDictionary["tags"] = category.tags.map { $0.rawValue }
        try await documentRef.setData(categoryDictionary)
    }
}
