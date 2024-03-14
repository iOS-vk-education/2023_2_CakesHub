//
//  FirestoreCollections.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import Firebase

/// Firestore collections
enum FirestoreCollections: String {
    case users
    case products
}

extension FirestoreCollections {

    var document: DocumentReference {
        Firestore.firestore().document(rawValue)
    }

    var collection: CollectionReference {
        Firestore.firestore().collection(rawValue)
    }
}
