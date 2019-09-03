//
//  TasksListTasksListPresenter.swift
//  Tasks
//
//  Created by Alexey on 13/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import PromiseKit
import UIKit

protocol TasksListModuleInput: class {}

class TasksListPresenter: TasksListModuleInput {
    weak var view: TasksListViewInput?
    var router: TasksListRouterInput?
    var displayManager: TasksListDisplayManager?
    var tasksService: TasksServiceProtocol!

    // MARK: Interactor methods

    func loadResources() {
        firstly {
            tasksService.getAll()
        }.done { tasksList in
            self.dataIsReady(tasksList: tasksList)
        }.catch { error in
            print(error.localizedDescription)
        }
    }

    func deleteTask(by taskId: Int) -> Promise<Data> {
        return tasksService.deleteTask(by: taskId)
    }

    func dataIsReady(tasksList: [Task]) {
        displayManager = TasksListDisplayManagerImp(tasksList: tasksList)
        displayManager?.set(output: self)
        view?.setup(displayManager)
    }
}

extension TasksListPresenter: TasksListViewOutput {
    func viewIsReady() {
        view?.setupInitialState()
        loadResources()
    }
}

extension TasksListPresenter: TasksListDisplayManagerDelegate {
    func deleteTaskFromList(with taskId: Int) {
        firstly {
            deleteTask(by: taskId)
        }.done { _ in
            self.loadResources()
        }.catch { error in
            print(error.localizedDescription)
        }
    }

    func passDataToNextScene(currentTask: Task) {
        router?.passDataToNextScene(currentTask: currentTask)
    }
}
