//
//  CategoryService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol CategoryServiceProtocol: AnyObject {
    func fetch() async throws -> [FBCategoryModel]
    func create(with category: FBCategoryModel) async throws
    func fetch(tags: Set<FBCategoryModel.Tag>) async throws -> [FBCategoryModel]
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

    func fetch() async throws -> [FBCategoryModel] {
        let snapshot = try await firestore.collection(collection).getDocuments()
        let categories = snapshot.documents.compactMap {
            FBCategoryModel(dictionary: $0.data())
        }
        return categories
    }

    func create(with category: FBCategoryModel) async throws {
        let documentRef = firestore.collection(collection).document(category.id)
        var categoryDictionary = category.dictionaryRepresentation
        categoryDictionary["tags"] = category.tags.map { $0.rawValue }
        try await documentRef.setData(categoryDictionary)
    }

    func fetch(tags: Set<FBCategoryModel.Tag>) async throws -> [FBCategoryModel] {
        let query = firestore.collection(collection).whereField("tags", arrayContainsAny: tags.map { $0.rawValue })
        let snapshot = try await query.getDocuments()
        let categories = snapshot.documents.compactMap {
            FBCategoryModel(dictionary: $0.data())
        }
        return categories
    }
}
