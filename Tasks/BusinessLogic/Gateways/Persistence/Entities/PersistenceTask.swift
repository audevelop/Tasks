//
//  PersistenceTask.swift
//  Tasks
//
//  Created by Alexey on 20/04/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Foundation
import RealmSwift

final class PersistenceTask: Object, PlainTransformable {
    typealias PlainType = Task

    @objc dynamic var title: String = ""
    @objc dynamic var descriptionTask: String = ""
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var taskId: Int = 0

    var plainObject: PlainType {
        return Task(managed: self)
    }

    convenience init(plain object: PlainType) {
        self.init()
        set(with: object)
    }

    override static func primaryKey() -> String {
        return "taskId"
    }

    @discardableResult
    public func set(with plain: PlainType) -> Self {
        title = plain.title
        descriptionTask = plain.descriptionTask ?? ""
        startDate = plain.startDate
        endDate = plain.endDate
        taskId = plain.taskId ?? 0
        return self
    }
}

extension Task: ManagedTransformable {
    typealias ManagedObject = PersistenceTask

    var managedObject: ManagedObject {
        return PersistenceTask(plain: self)
    }

    init(managed object: ManagedObject) {
        self.init()
        title = object.title
        descriptionTask = object.descriptionTask
        startDate = object.startDate
        endDate = object.endDate
        taskId = object.taskId
    }
}
