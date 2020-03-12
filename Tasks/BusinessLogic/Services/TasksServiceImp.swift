//
//  TasksServiceImp.swift
//  Tasks
//
//  Created by Alexey on 15/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class TasksServiceImp: TasksServiceProtocol {
    private let tasksRepository: TasksGateway
    private let persistenceGateway: PersistenceGateway

    init(
        tasksRepository: TasksGateway,
        persistenceGateway: PersistenceGateway
    ) {
        self.tasksRepository = tasksRepository
        self.persistenceGateway = persistenceGateway
    }

    // MARK: Methods of TasksServiceProtocol

    func getAll() -> Single<[Task]> {
        return tasksRepository.getAll()
    }

    func save(task: Task) -> Completable {
        return tasksRepository.save(task: task)
    }

    func getTask(by taskId: Int) -> Single<Task> {
        return tasksRepository.getTask(by: taskId)
    }

    func deleteTask(by taskId: Int) -> Completable {
        return tasksRepository.deleteTask(by: taskId)
    }

    func saveToPerstistence(task: Task) {
        persistenceGateway.save(objects: [task])
    }

    func saveAllToPerstistence(tasks: [Task]) {
        persistenceGateway.save(objects: tasks)
    }

    func deleteAllDataFromPersistence() {
        persistenceGateway.deleteAll()
    }

    func deleteTaskFromPersistence(task: Task) {
        persistenceGateway.delete(object: task)
    }

    func getAllFromPersistence() -> Single<[Task]> {
        let tasks = persistenceGateway.get(Task.self)
        return tasks
    }

    // TODO: temporary solution
    func getAllForNotific() -> Results<PersistenceTask>? {
        return persistenceGateway.fetchAll(PersistenceTask.self)
    }
}
