//
//  TasksListTasksListConfigurator.swift
//  Tasks
//
//  Created by Alexey on 13/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class TasksListModuleAssemblyContainer: Assembly {
    func assemble(container: Container) {
        container.register(TasksListRouter.self) { (_, viewContoller: TasksListViewController) in
            let router = TasksListRouter()
            router.transitionHandler = viewContoller
            return router
        }

        container.register(TasksListPresenter.self) { (r, viewController: TasksListViewController) in
            let presenter = TasksListPresenter()
            presenter.view = viewController
            presenter.tasksService = r.resolve(TasksServiceProtocol.self)
            presenter.router = r.resolve(TasksListRouter.self, argument: viewController)
            return presenter
        }

        container.storyboardInitCompleted(TasksListViewController.self) { r, viewController in
            viewController.output = r.resolve(TasksListPresenter.self, argument: viewController)
        }
    }
}
