//
//  TasksServiceProtocol.swift
//  Tasks
//
//  Created by Alexey on 15/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import PromiseKit

protocol TasksServiceProtocol {
    func getAll() -> Promise<[Task]>
    func save(task: Task) -> Promise<Data>
    func getTask(by taskID: Int) -> Promise<Task>
    func deleteTask(by taskId: Int) -> Promise<Data>
}
