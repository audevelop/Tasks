//
//  RealmRepository.swift
//  Tasks
//
//  Created by Alexey on 11/04/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

// TODO: add Single error handle
// TODO: make framework w/ generics

enum PersistenceError: Error {
    case emptyArray
    case noPrimaryKeyInClass
    case noPrimaryKeyValue
}

typealias ResultsBlock<T: ManagedTransformable> = (Results<T.ManagedType>) -> Results<T.ManagedType>

protocol PersistenceGateway {
    func delete<T: ManagedTransformable>(object: T)
    func delete<T: ManagedTransformable>(objects: [T])
    func save<T: ManagedTransformable>(object: T)
    func save<T: ManagedTransformable>(objects: [T])
    func get<T: ManagedTransformable>(_ type: T.Type) -> Single<[T]>
    func fetchAll<T: Object>(_ type: T.Type) -> Results<T>?
    func deleteAll()
}

class PersistenceGatewayImp: PersistenceGateway {
    private let config: Realm.Configuration

    init(configuration: Realm.Configuration) {
        config = configuration
    }

    func realm() throws -> Realm {
        let realm = try Realm(configuration: config)
        return realm
    }

    func fetchAll<T: Object>(_: T.Type) -> Results<T>? {
        do {
            let realm = try self.realm()
            return realm.objects(T.self)
        } catch {
            print(error)
        }
        return nil
    }

    func deleteAll() {
        do {
            let realm = try self.realm()

            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }

    func delete<T: ManagedTransformable>(object: T) {
        return delete(objects: [object])
    }

    func delete<T: ManagedTransformable>(objects: [T]) {
        guard let primaryKey = T.ManagedType.primaryKey() else {
            print(PersistenceError.noPrimaryKeyInClass)
            return
        }
        do {
            let realm = try self.realm()
            let primaryKeyValues = objects.compactMap { $0.managedObject.value(forKey: primaryKey) }
            guard !primaryKeyValues.isEmpty else {
                print(PersistenceError.noPrimaryKeyValue)
                return
            }
            let predicate = NSPredicate(format: "\(primaryKey) IN %@", primaryKeyValues)

            try realm.write {
                let objectsToDrop = realm.objects(T.ManagedType.self).filter(predicate)
                realm.delete(objectsToDrop)
                print("Task successfully deleted from Realm DataBase")
            }
        } catch {
            print(error)
        }
    }

    func save<T: ManagedTransformable>(object: T) {
        return save(objects: [object])
    }

    func save<T: ManagedTransformable>(objects: [T]) {
        guard let firstObject = objects.first else {
            print(PersistenceError.emptyArray)
            return
        }
        do {
            let realm = try self.realm()

            try realm.write {
                let isNeedUpdate = self.isNeedUpdateObject(firstObject)
                let managedObjects = objects.map { $0.managedObject }
                realm.add(managedObjects, update: isNeedUpdate)
            }
        } catch {
            print(error)
        }
    }

    func get<T: ManagedTransformable>(_: T.Type) -> Single<[T]> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            let disposable = Disposables.create()
            guard let self = self else {
                return disposable
            }
            do {
                let realm = try self.realm()
                let objects: [T] = realm
                    .objects(T.ManagedType.self)
                    .map { $0.plainObject }
                single(.success(objects))
            } catch {
                single(.error(TasksError.wrongValue))
            }
            return disposable
        })
    }

    private func isNeedUpdateObject<T: ManagedTransformable>(_: T) -> Bool {
        return T.ManagedType.primaryKey() != nil
    }
}
