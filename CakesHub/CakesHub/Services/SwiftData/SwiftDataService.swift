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
    func create<SDType: SDModelable, FBType: FBModelable>(object: FBType,
                                                          configureSDModel: @escaping (FBType) -> SDType?,
                                                          configurePredicate: @escaping (SDType) -> Predicate<SDType>,
                                                          equalCheck: ((_ obj: FBType, _ sdObject: SDType) -> Bool)?)
    func create<SDType: SDModelable, FBType: FBModelable>(objects: [FBType],
                                                          configureSDModel: @escaping (FBType) -> SDType?,
                                                          configurePredicate: @escaping (SDType) -> Predicate<SDType>,
                                                          equalCheck: ((_ obj: FBType, _ sdObject: SDType) -> Bool)?)
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

    func create<SDType: SDModelable, FBType: FBModelable>(
        object: FBType,
        configureSDModel: @escaping (FBType) -> SDType?,
        configurePredicate: @escaping (SDType) -> Predicate<SDType>,
        equalCheck: ((_ obj: FBType, _ sdObject: SDType) -> Bool)? = nil
    ) {
        saveQueue.async {
            guard let sdObject = configureSDModel(object) else {
                Logger.log(kind: .error, message: "Текущая модель isNil. Так не должно быть")
                return
            }

            guard self.isEmpty(
                fbObject: object,
                predicate: configurePredicate(sdObject),
                equalCheck: equalCheck
            ) else {
                Logger.log(message: "Объект уже существует в БД!")
                return
            }

            self.context.insert(sdObject)
            Logger.log(message: "Создан новый торт!")

            do {
                try self.context.save()
            } catch {
                Logger.log(kind: .error, message: error)
            }
        }
    }

    func create<SDType: SDModelable, FBType: FBModelable>(
        objects: [FBType],
        configureSDModel: @escaping (FBType) -> SDType?,
        configurePredicate: @escaping (SDType) -> Predicate<SDType>,
        equalCheck: ((_ obj: FBType, _ sdObject: SDType) -> Bool)? = nil
    ) {
        saveQueue.async {
            objects.forEach { fbObject in
                guard let sdObject = configureSDModel(fbObject) else {
                    Logger.log(kind: .error, message: "Текущая модель isNil. Так не должно быть")
                    return
                }

                guard self.isEmpty(
                    fbObject: fbObject,
                    predicate: configurePredicate(sdObject),
                    equalCheck: equalCheck
                ) else {
                    Logger.log(message: "Объект уже существует в БД!")
                    return
                }
                
                self.context.insert(sdObject)
                Logger.log(message: "Создан новый торт!")
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

    func isEmpty<SDType: SDModelable, FBType: FBModelable>(
        fbObject: FBType,
        predicate: Predicate<SDType>,
        equalCheck: ((_ obj: FBType, _ sdObject: SDType) -> Bool)? = nil
    ) -> Bool {
        let sdObject = fetch(predicate: predicate)
        guard let sdObject, let equalCheck else {
            Logger.log(kind: .error, message: "sdObject or equalCheck is nil")
            return sdObject.isNil
        }
        let isEqual = equalCheck(fbObject, sdObject)
        return !isEqual
    }
}
