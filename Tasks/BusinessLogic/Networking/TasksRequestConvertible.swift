//
//  TasksRequestConvertible.swift
//  Tasks
//
//  Created by Alexey on 03/10/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Alamofire
import Foundation

protocol TasksRequestConvertible: RequestConvertible {
}

extension TasksRequestConvertible {
    var base: URL {
        return Constants.current.defaultUrlLocalServer
    }
}

struct TasksListRequest: TasksRequestConvertible {
    typealias Result = [Task]
    var path: String = Constants.current.tasksFolder
    var method: HTTPMethod = .get
    var params: Parameters = [:]
    var encoding: ParameterEncoding = URLEncoding.default
}

struct TaskRequest: TasksRequestConvertible {
    typealias Result = Task
    var path: String
    var method: HTTPMethod = .get
    var params: Parameters = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    init(taskId: Int) {
        path = Constants.current.tasksFolder + "/\(taskId)"
    }
}

struct TaskDeleteRequest: TasksRequestConvertible {
    typealias Result = Task
    var path: String
    var method: HTTPMethod = .delete
    var params: Parameters = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    init(taskId: Int) {
        path = Constants.current.tasksFolder + "/\(taskId)"
    }
}

struct TaskSaveRequest: TasksRequestConvertible {
    typealias Result = Task
    var path: String
    var method: HTTPMethod
    var params: Parameters = [:]
    var encoding: ParameterEncoding = URLEncoding.default

    init(task: Task) {
        if let taskId = task.taskId {
            method = .put
            path = Constants.current.tasksFolder + "/\(taskId)"
        } else {
            method = .post
            path = Constants.current.tasksFolder
        }
        guard let dict = task.dictionary() else {
            return
        }
        params = dict
    }
}
