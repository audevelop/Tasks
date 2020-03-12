//
//  TasksServiceProtocol.swift
//  Tasks
//
//  Created by Alexey on 15/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import RealmSwift
import RxSwift

protocol TasksServiceProtocol {
    func getAll() -> Single<[Task]>
    func save(task: Task) -> Completable
    func getTask(by taskId: Int) -> Single<Task>
    func deleteTask(by taskId: Int) -> Completable
    func saveToPerstistence(task: Task)
    func saveAllToPerstistence(tasks: [Task])
    func getAllFromPersistence() -> Single<[Task]>
    func getAllForNotific() -> Results<PersistenceTask>?
    func deleteAllDataFromPersistence()
    func deleteTaskFromPersistence(task: Task)
}
