//
//  TasksDetailsTasksDetailsConfigurator.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class TasksDetailsModuleAssemblyContainer: Assembly {
    func assemble(container: Container) {
        container.register(TasksDetailsRouter.self) { (_, viewController: TasksDetailsViewController) in
            let router = TasksDetailsRouter()
            router.transitionHandler = viewController
            return router
        }

        container.register(TasksDetailsPresenter.self) { (r, viewController: TasksDetailsViewController) in
            let presenter = TasksDetailsPresenter()
            presenter.view = viewController
            presenter.tasksService = r.resolve(TasksServiceProtocol.self)
            presenter.router = r.resolve(TasksDetailsRouter.self, argument: viewController)
            let dateFormatterToString = r.resolve(DateToStringProtocol.self, name: FormatterType.taskDateFormatterShort.rawValue)!
            presenter.dateRangeFormatter = r.resolve(DateRangeFormatter.self, argument: dateFormatterToString)
            return presenter
        }

        container.storyboardInitCompleted(TasksDetailsViewController.self) { r, viewController in
            viewController.output = r.resolve(TasksDetailsPresenter.self, argument: viewController)
            viewController.moduleInput = r.resolve(TasksDetailsPresenter.self, argument: viewController)
        }
    }
}
