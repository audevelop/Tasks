//
//  TasksListDisplayManager.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import Reusable
import UIKit

protocol TasksListDisplayManagerDelegate: class {
    func deleteTaskFromList(with taskId: Int)
    func passDataToNextScene(currentTask: Task)
}

protocol TasksListDisplayManager: class {
    func set(output: TasksListDisplayManagerDelegate?)
    func set(tableView: UITableView)
}

class TasksListDisplayManagerImp: NSObject {
    weak var tableView: UITableView?
    weak var delegate: TasksListDisplayManagerDelegate?

    var tasksList: [Task] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    override init() {
        super.init()
    }

    init(tasksList: [Task]) {
        super.init()
        self.tasksList = tasksList
    }
}

extension TasksListDisplayManagerImp: TasksListDisplayManager {
    func set(output: TasksListDisplayManagerDelegate?) {
        delegate = output
    }

    func set(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }
}

extension TasksListDisplayManagerImp: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tasksList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TitleCell
        let task = tasksList[indexPath.row]
        cell.fill(with: task)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let currentTask = tasksList[indexPath.row]
            print(currentTask)
            delegate?.passDataToNextScene(currentTask: currentTask)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_: UITableView, titleForDeleteConfirmationButtonForRowAt _: IndexPath) -> String? {
        return "DELETE"
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let taskID = tasksList[indexPath.row].taskId {
            print(tasksList[indexPath.row])
            delegate?.deleteTaskFromList(with: taskID)
        }
    }
}
