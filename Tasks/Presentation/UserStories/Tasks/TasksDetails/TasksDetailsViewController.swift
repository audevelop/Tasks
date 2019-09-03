//
//  TasksDetailsTasksDetailsViewController.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import UIKit

protocol TasksDetailsViewInput: class {
    func setupInitialState()
    func initTextFields(with descriptionTask: String?, title: String, timeFrame: String)
}

protocol TasksDetailsViewOutput {
    func viewIsAppear()
    func didTappedEditButton()
}

class TasksDetailsViewController: UIViewController {
    var output: TasksDetailsViewOutput!

    @IBOutlet var tasksTimeFrame: UILabel!
    @IBOutlet var tasksDescription: UITextView!

    // MARK: Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewIsAppear()
    }

    @IBAction func tappedEditButton(_: UIBarButtonItem) {
        output.didTappedEditButton()
    }
}

// MARK: TasksDetailsViewInput

extension TasksDetailsViewController: TasksDetailsViewInput {
    func setupInitialState() {
    }

    func initTextFields(with descriptionTask: String?, title: String, timeFrame: String) {
        tasksTimeFrame.text = timeFrame
        tasksDescription.text = descriptionTask
        navigationItem.title = title
    }
}
