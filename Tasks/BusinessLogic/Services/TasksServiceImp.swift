//
//  TasksServiceImp.swift
//  Tasks
//
//  Created by Alexey on 15/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import PromiseKit

class TasksServiceImp: TasksServiceProtocol {
    let tasksRepository: NetworkPepository

    init(tasksRepository: NetworkPepository) {
        self.tasksRepository = tasksRepository
    }

    // MARK: Methods of TasksServiceProtocol

    func getAll() -> Promise<[Task]> {
        return tasksRepository.object(TasksListRequest())
    }

    func save(task: Task) -> Promise<Data> {
        return tasksRepository.data(TaskSaveRequest(task: task))
    }

    func getTask(by taskID: Int) -> Promise<Task> {
        return tasksRepository.object(TaskRequest(taskId: taskID))
    }

    func deleteTask(by taskId: Int) -> Promise<Data> {
        return tasksRepository.data(TaskDeleteRequest(taskId: taskId))
    }
}
