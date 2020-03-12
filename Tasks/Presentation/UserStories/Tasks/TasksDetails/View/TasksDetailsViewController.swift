//
//  TasksDetailsTasksDetailsViewController.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

class TasksDetailsViewController: UIViewController {
    var viewModel: TaskViewModel!

    @IBOutlet var tasksTimeFrame: UILabel!
    @IBOutlet var tasksDescription: UITextView!
    private let bag = DisposeBag()

    // MARK: Life cycle

    // TODO: implement extension to NSObject + diTag in storyboard, or add NSObject to VC in SB
    override func awakeFromNib() {
        super.awakeFromNib()
        TasksDetailsAssembly.instance().inject(into: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinders()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewIsAppear()
    }

    @IBAction func tappedEditButton(_: UIBarButtonItem) {
        performSegue(withIdentifier: StoryboardSegue.Main.fromTitleToTask.rawValue, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == StoryboardSegue.Main.fromTitleToTask.rawValue,
            let nextViewController = segue.destination as? AddEditTaskViewController {
            nextViewController.viewModel.setTask(task: viewModel.task.value)
        }
    }
}

// MARK: TasksDetailsViewInput

private extension TasksDetailsViewController {
    func setupBinders() {
        viewModel.task
            .asDriver()
            .map { $0.descriptionTask }
            .drive(tasksDescription.rx.text)
            .disposed(by: bag)

        viewModel.tasksTimeFrame
            .asDriver()
            .drive(tasksTimeFrame.rx.text)
            .disposed(by: bag)

        viewModel.task
            .asObservable()
            .map { $0.title }
            .observeOn(MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: bag)
    }
}
