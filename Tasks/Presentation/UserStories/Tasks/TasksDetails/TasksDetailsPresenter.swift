//
//  TasksDetailsPresenter.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import PromiseKit
import ViperMcFlurry

protocol TasksDetailsModuleInput: class, RamblerViperModuleInput {
    func configureCurrentModuleWithTask(task: Task)
}

class TasksDetailsPresenter: NSObject {
    weak var view: TasksDetailsViewInput?
    var router: TasksDetailsRouterInput?
    var dateRangeFormatter: DateRangeFormatter?
    var currentTask: Task?
    var tasksService: TasksServiceProtocol!

    // Mark: Interactor methods
    func getTask(by taskId: Int) -> Promise<Task> {
        return tasksService.getTask(by: taskId)
    }
}

extension TasksDetailsPresenter: TasksDetailsModuleInput {
    func configureCurrentModuleWithTask(task: Task) {
        currentTask = task
    }
}

extension TasksDetailsPresenter: TasksDetailsViewOutput {
    func viewIsAppear() {
        guard let task = currentTask, let taskID = task.taskId else {
            return
        }
        firstly {
            getTask(by: taskID)
        }.done { task in
            self.initCurrentTask(task: task)
        }.catch { error in
            print(error)
        }
    }

    func didTappedEditButton() {
        guard let task = currentTask else {
            return
        }
        router?.passDataToNextScene(currentTask: task)
    }

    // MARK: - Private methods

    private func initCurrentTask(task: Task) {
        currentTask = task
        guard let tasksTimeframe = dateRangeFormatter?.string(from: task.startDate, to: task.endDate) else {
            return
        }
        view?.initTextFields(with: task.descriptionTask, title: task.title, timeFrame: tasksTimeframe)
    }
}
