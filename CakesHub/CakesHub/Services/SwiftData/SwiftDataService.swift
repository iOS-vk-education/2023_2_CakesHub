//
//  SwiftDataService.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 19.04.2024.
//

import Foundation
import SwiftData

protocol SwiftDataServiceProtocol {
    func fetchData<T: SDModelable>() -> [T]
    func fetchObject<T: SDModelable>(predicate: Predicate<T>) -> T?
    func writeObjects<FBType: FBModelable, SDType: SDModelable>(objects: [FBType], completion: CHMResultBlock<SDType, SwiftDataService.SwiftDataError>?)
}

// MARK: - SwiftDataService

final class SwiftDataService {

    let context: ModelContext
    private let saveQueue = DispatchQueue(label: "com.vk.SwiftDataService", qos: .utility, attributes: [.concurrent])

    init(context: ModelContext) {
        self.context = context
    }
}

// MARK: - Memory CRUD

extension SwiftDataService: SwiftDataServiceProtocol {

    func fetchData<T: SDModelable>() -> [T] {
        let fetchDescriptor = FetchDescriptor<T>()

        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            Logger.log(kind: .error, message: error)
            return []
        }
    }

    func fetchObject<T: SDModelable>(predicate: Predicate<T>) -> T? {
        var fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        return (try? context.fetch(fetchDescriptor))?.first
    }

    func writeObjects<FBType: FBModelable, SDType: SDModelable>(objects: [FBType], completion: CHMResultBlock<SDType, SwiftDataError>?) {
        saveQueue.async {
            objects.forEach { object in
                guard !self.isExist(by: object) else {
                    Logger.log(message: "Объект уже создан")
                    completion?(.failure(.objectIsCreated))
                    return
                }

                // Создаем объект типа T1 на основе объекта типа T
                guard let fbObject = object as? SDType.FBModelType, let sdObject = SDType(fbModel: fbObject) else {
                    return
                }

                self.context.insert(sdObject)
            }

            do {
                try self.context.save()
            } catch {
                completion?(.failure(.saveError))
                Logger.log(message: "Ошибка при сохранении: \(error)")
            }
        }
    }
}

// MARK: - Helper

private extension SwiftDataService {

    func isExist<T: FBModelable>(by object: T) -> Bool {
        true
    }
}

// MARK: - SwiftDataError

extension SwiftDataService {

    enum SwiftDataError: Error {
        case objectIsCreated
        case saveError
    }
}
