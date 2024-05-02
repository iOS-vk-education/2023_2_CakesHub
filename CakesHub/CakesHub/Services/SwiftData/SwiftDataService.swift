//
//  SwiftDataService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.04.2024.
//

import Foundation
import SwiftData

protocol SwiftDataServiceProtocol {
    func fetch<T: SDModelable>() -> [T]
    func fetch<T: SDModelable>(predicate: Predicate<T>) -> T?
    func create<SDType: SDModelable>(object: SDType, configurationPredicate: @escaping (SDType) -> Predicate<SDType>)
    func create<SDType: SDModelable>(objects: [SDType], configurationPredicate: @escaping (SDType) -> Predicate<SDType>)
}

// MARK: - SwiftDataService

final class SwiftDataService {

    private let context: ModelContext
    private let saveQueue = DispatchQueue(label: "com.vk.SwiftDataService", qos: .utility, attributes: [.concurrent])

    init(context: ModelContext) {
        self.context = context
    }
}

// MARK: - Memory CRUD

extension SwiftDataService: SwiftDataServiceProtocol {

    func fetch<T: SDModelable>() -> [T] {
        let fetchDescriptor = FetchDescriptor<T>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            Logger.log(kind: .error, message: error)
            return []
        }
    }

    func fetch<T: SDModelable>(predicate: Predicate<T>) -> T? {
        var fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        return (try? context.fetch(fetchDescriptor))?.first
    }

    func create<SDType: SDModelable>(
        object: SDType,
        configurationPredicate: @escaping (SDType) -> Predicate<SDType>
    ) {
        saveQueue.async {
            guard self.isEmpty(object: object, predicate: configurationPredicate(object)) else {
                Logger.log(message: "Объект уже существует в БД!")
                return
            }

            self.context.insert(object)

            do {
                try self.context.save()
            } catch {
                Logger.log(kind: .error, message: error)
            }
        }
    }

    func create<SDType: SDModelable>(objects: [SDType], configurationPredicate: @escaping (SDType) -> Predicate<SDType>) {
        saveQueue.async {
            objects.forEach { object in
                guard self.isEmpty(object: object, predicate: configurationPredicate(object)) else {
                    Logger.log(message: "Объект уже существует в БД!")
                    return
                }
                
                self.context.insert(object)
            }

            do {
                try self.context.save()
            } catch {
                Logger.log(message: "ошибка при сохранении `swift data model`: \(error)")
            }
        }
    }
}

// MARK: - Helper

private extension SwiftDataService {

    func isEmpty<SDType: SDModelable>(object: SDType, predicate: Predicate<SDType>) -> Bool {
        fetch(predicate: predicate).isNil
    }
}
