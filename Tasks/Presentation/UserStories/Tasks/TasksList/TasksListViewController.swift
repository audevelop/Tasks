//
//  TasksListTasksListViewController.swift
//  Tasks
//
//  Created by Alexey on 13/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import UIKit

protocol TasksListViewInput: class {
    func setupInitialState()
    func setup(_ tasksListDisplayManager: TasksListDisplayManager?)
}

protocol TasksListViewOutput {
    func viewIsReady()
}

class TasksListViewController: UIViewController, TasksListViewInput {
    var output: TasksListViewOutput!

    @IBOutlet var tableView: UITableView!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewIsReady()
    }

    // MARK: TasksListViewInput

    func setupInitialState() {
    }

    func setup(_ tasksListDisplayManager: TasksListDisplayManager?) {
        tasksListDisplayManager?.set(tableView: tableView)
    }
}
