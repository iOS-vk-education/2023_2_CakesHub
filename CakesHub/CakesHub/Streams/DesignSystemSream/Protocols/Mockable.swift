//
//  Mockable.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03.03.2024.
//

import Foundation

protocol Mockable {
    static var mockData: Self { get }
}
