//
//  TasksListAssembly.swift
//  Tasks
//
//  Created by Alexey on 04/04/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import EasyDi
import Foundation

// swiftformat:disable redundantSelf

final class TasksListAssembly: Assembly {
    private lazy var servicesAssembly: ServicesAssembly = context.assembly()

    func inject(into view: TasksListViewController) {
        defineInjection(key: "view", into: view) {
            $0.viewModel = self.viewModel
            return $0
        }
    }

    var view: TasksListViewController {
        return definePlaceholder()
    }

    var viewModel: TasksListViewModel {
        return define(
            init:
            TasksListViewModelImp(
                tasksService: self.servicesAssembly.tasksService
            )
        )
    }
}
