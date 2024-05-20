//
//  Typealias.swift
//
//
//  Created by Dmitriy Permyakov on 10.04.2024.
//

import Foundation

typealias MKRVoidBlock = () -> Void
typealias MKRBoolBlock = (Bool) -> Void
typealias MKRStringBlock = (String) -> Void
typealias MKRIntBlock = (Int) -> Void
typealias MKResultBlock<T, T1: Error> = (Result<T, T1>) -> Void
