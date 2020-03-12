//
//  TaskViewModel.swift
//  Tasks
//
//  Created by Alexey on 11/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Foundation
import RxSwift

// swiftformat:disable redundantSelf

protocol TaskViewModel {
    var task: Variable<Task> { get }
    var tasksTimeFrame: Variable<String> { get }
    func viewIsAppear()
    func setTask(task: Task)
}

class TaskViewModelImp: TaskViewModel {
    private var dateRangeFormatter: DateRangeFormatter
    private var tasksService: TasksServiceProtocol
    var task: Variable<Task> = .init(Task())
    var tasksTimeFrame: Variable<String> = .init("")
    private let bag: DisposeBag = .init()

    init(
        tasksService: TasksServiceProtocol,
        dateRangeFormatter: DateRangeFormatter
    ) {
        self.tasksService = tasksService
        self.dateRangeFormatter = dateRangeFormatter
    }

    func viewIsAppear() {
        guard let taskId = task.value.taskId else {
            return
        }
        tasksService
            .getTask(by: taskId)
            .subscribe(
                onSuccess: { [weak self] task in
                    self?.initCurrentTask(task: task)
            }) { error in
                print(error)
            }.disposed(by: bag)
    }

    func setTask(task: Task) {
        self.task.value = task
    }
}

private extension TaskViewModelImp {
    func initCurrentTask(task: Task) {
        self.task.value = task
        tasksTimeFrame.value = dateRangeFormatter.string(
            from: task.startDate,
            to: task.endDate
        )
    }
}
