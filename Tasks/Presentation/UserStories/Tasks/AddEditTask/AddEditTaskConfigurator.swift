//
//  AddEditTaskAddEditTaskConfigurator.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class AddEditTaskModuleAssemblyContainer: Assembly {
    func assemble(container: Container) {
        container.register(AddEditTaskRouter.self) { (_, viewController: AddEditTaskViewController) in
            let router = AddEditTaskRouter()
            router.transitionHandler = viewController
            return router
        }

        container.register(AddEditTaskPresenter.self) { (r, viewController: AddEditTaskViewController) in
            let presenter = AddEditTaskPresenter()
            presenter.view = viewController
            presenter.router = r.resolve(AddEditTaskRouter.self, argument: viewController)
            presenter.tasksService = r.resolve(TasksServiceProtocol.self)
            presenter.dateFormatterToString = r.resolve(DateToStringProtocol.self, name: FormatterType.taskDateFormatterShort.rawValue)!
            presenter.dateFormatterParse = r.resolve(DateParserProtocol.self, name: FormatterType.taskDateParser.rawValue)!
            return presenter
        }

        container.storyboardInitCompleted(AddEditTaskViewController.self) { r, viewController in
            viewController.output = r.resolve(AddEditTaskPresenter.self, argument: viewController)
            viewController.moduleInput = r.resolve(AddEditTaskPresenter.self, argument: viewController)
            viewController.visualStateManager.dateFormatterToString = r.resolve(DateToStringProtocol.self, name: FormatterType.taskDateFormatterShort.rawValue)!
        }
    }
}
