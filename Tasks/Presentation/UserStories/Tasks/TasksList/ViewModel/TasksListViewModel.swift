//
//  TasksListViewModel.swift
//  Tasks
//
//  Created by Alexey on 11/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import RealmSwift
import RxSwift
import UIKit

protocol TasksListViewModel {
    var tasksList: Variable<[Task]> { get }
    var currentTask: Task? { get }
    func deleteTaskFromList(with taskId: Int)
    func viewDidLoad()
    func setCurrentTask(taskId: Int)
}

class TasksListViewModelImp: TasksListViewModel {
    private var tasksService: TasksServiceProtocol
    private var tasksToken: NotificationToken?
    private var persistenceTasks: Results<PersistenceTask>?
    var currentTask: Task?
    private let bag = DisposeBag()

    var tasksList: Variable<[Task]> = .init([])

    init(tasksService: TasksServiceProtocol) {
        self.tasksService = tasksService
    }

    deinit {
        tasksToken?.invalidate()
    }

    func viewDidLoad() {
        makeNotification()
        loadResources()
    }

    func deleteTaskFromList(with taskId: Int) {
        tasksService
            .getTask(by: taskId)
            .subscribe(
                onSuccess: { [weak self] task in
                    self?.deleteTaskFromPersAndNetw(task: task)
            }) { error in
                print(error)
            }
            .disposed(by: bag)
    }

    func setCurrentTask(taskId: Int) {
        currentTask = tasksList.value[taskId]
    }
}

// MARK: - Private Methods

private extension TasksListViewModelImp {
    private func makeNotification() {
        let tasksPlain = tasksService.getAllForNotific()
        persistenceTasks = tasksPlain
        tasksToken = persistenceTasks?.observe { changes in
            switch changes {
            case .initial:
                self.reloadScrenWithNewRealmData()
            case let .update(_, deletions, insertions, updates):
                self.reloadScrenWithNewRealmData()
            case .error:
                break
            }
        }
    }

    func loadResources() {
        tasksService
            .getAll()
            .subscribe(
                onSuccess: { [weak self] tasksList in
                    self?.dataIsReady(tasksList: tasksList)
            }) { error in
                print(error.localizedDescription)
            }.disposed(by: bag)
    }

    func dataIsReady(tasksList: [Task]) {
        tasksService.saveAllToPerstistence(tasks: tasksList)
    }

    func reloadScrenWithNewRealmData() {
        tasksService
            .getAllFromPersistence()
            .subscribe(
                onSuccess: { [weak self] tasksPersistence in
                    self?.tasksList.value = tasksPersistence
                    print(tasksPersistence.count)
            }) { error in
                print(error)
            }
            .disposed(by: bag)
    }

    func deleteTaskFromPersAndNetw(task: Task) {
        tasksService.deleteTaskFromPersistence(task: task)
        guard let taskId = task.taskId else {
            return
        }

        tasksService
            .deleteTask(by: taskId)
            .subscribe(
                onCompleted: {
                    print("task with id:\(taskId) successfully deleted from network")
            }) { error in
                print(error)
            }.disposed(by: bag)
    }
}
