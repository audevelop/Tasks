//
//  TasksListViewController.swift
//  Tasks
//
//  Created by Alexey on 13/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

class TasksListViewController: UIViewController {
    var viewModel: TasksListViewModel!
    private let bag: DisposeBag = .init()
    @IBOutlet var tableView: UITableView!

    // MARK: Life cycle

    // TODO: implement extension to NSObject + diTag in storyboard, or add NSObject to VC in SB
    override func awakeFromNib() {
        super.awakeFromNib()
        TasksListAssembly.instance().inject(into: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        viewModel.viewDidLoad()
        configureBindings(viewModel: viewModel)
            .disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == StoryboardSegue.Main.titleSegue.rawValue,
            let nextViewController = segue.destination as? TasksDetailsViewController,
            let currentTask = viewModel.currentTask {
            nextViewController.viewModel.setTask(task: currentTask)
        }
    }
}

// MARK: Private methods

private extension TasksListViewController {
    func configureTable() {
        tableView.register(cellType: TitleCell.self)
    }

    func configureBindings(viewModel: TasksListViewModel) -> [Disposable] {
        return [
            viewModel
                .tasksList
                .asDriver()
                .drive(tableView.rx.items(
                    cellIdentifier: TitleCell.reuseIdentifier,
                    cellType: TitleCell.self
                )) { _, task, cell in
                    cell.fill(with: task)
                },

            tableView.rx.itemSelected
                .subscribe(onNext: { [weak self] indexPath in
                    self?.viewModel.setCurrentTask(taskId: indexPath.row)
                    self?.performSegue(
                        withIdentifier: StoryboardSegue.Main.titleSegue.rawValue,
                        sender: nil
                    )
                }),

            tableView.rx.itemDeleted
                .subscribe(onNext: { [weak self] indexPath in
                    if let taskID = self?.viewModel.tasksList.value[indexPath.row].taskId {
                        print(taskID)
                        self?.viewModel.deleteTaskFromList(with: taskID)
                    }
                }),

            viewModel
                .tasksList
                .asDriver()
                .drive(
                    onNext: { [weak self] _ in
                        self?.tableView.reloadData()
                    }
                ),
        ]
    }
}
