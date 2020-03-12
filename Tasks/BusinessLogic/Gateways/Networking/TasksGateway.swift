//
//  TasksGateway.swift
//  Tasks
//
//  Created by Alexey on 23/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift
// import RxAlamofire

// TODO: make framework w/ RxAlamofire and generics

protocol TasksGateway {
    func getAll() -> Single<[Task]>
    func save(task: Task) -> Completable
    func getTask(by taskId: Int) -> Single<Task>
    func deleteTask(by taskId: Int) -> Completable
}

class TasksGatewayImp: TasksGateway {
    private let baseUrl: URL
    private let sessionManager: SessionManager
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(baseUrl: URL, sessionManager: SessionManager, decoder: JSONDecoder, encoder: JSONEncoder) {
        self.baseUrl = baseUrl
        self.sessionManager = sessionManager
        self.decoder = decoder
        self.encoder = encoder
    }

    // MARK: TasksGateway protocol methods

    func getAll() -> Single<[Task]> {
        return sessionManager
            .request(
                baseUrl.appendingPathComponent(Constants.current.tasksFolder),
                method: .get
            )
            .validate()
            .responseArray(with: decoder)
    }

    func save(task: Task) -> Completable {
        return sessionManager
            .request(
                makeRequestForSave(task: task)
            )
            .validate()
            .responseVoid()
    }

    func getTask(by taskId: Int) -> Single<Task> {
        return sessionManager
            .request(
                baseUrl.appendingPathComponent(Constants.current.tasksFolder + "/\(taskId)"),
                method: .get
            )
            .validate()
            .responseObjectById(with: decoder)
    }

    func deleteTask(by taskId: Int) -> Completable {
        return sessionManager
            .request(
                baseUrl.appendingPathComponent("\(Constants.current.tasksFolder)/\(taskId)"),
                method: .delete
            )
            .validate()
            .responseVoid()
    }

    private func makeRequestForSave(task: Task) -> URLRequest {
        let jsonData = try? encoder.encode(task)
        var taskID = ""
        var httpMethod = HTTPMethod.post.rawValue
        if let id = task.taskId {
            taskID.append("/\(id)")
            httpMethod = HTTPMethod.put.rawValue
        }
        let url = baseUrl.appendingPathComponent("\(Constants.current.tasksFolder)\(taskID)")
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        return request
    }
}
