//
//  DictionaryConvertible.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.03.2024.
//

import Foundation

protocol DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] { get }
    init?(dictionary: [String: Any])
}

extension DictionaryConvertible {

    var dictionaryRepresentation: [String: Any] {
        var dict: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            if let nestedObject = value as? DictionaryConvertible {
                dict[label] = nestedObject.dictionaryRepresentation
            } else if let array = value as? [DictionaryConvertible] {
                dict[label] = array.map { $0.dictionaryRepresentation }
            } else {
                dict[label] = value
            }
        }
        
        return dict
    }
}
