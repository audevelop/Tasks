//
//  TasksListTasksListRouter.swift
//  Tasks
//
//  Created by Alexey on 13/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import ViperMcFlurry

protocol TasksListRouterInput {
    func passDataToNextScene(currentTask: Task)
}

class TasksListRouter: TasksListRouterInput {
    weak var transitionHandler: RamblerViperModuleTransitionHandlerProtocol?

    func passDataToNextScene(currentTask: Task) {
        transitionHandler?.openModule!(usingSegue: Segue.title.rawValue).thenChain { input in
            guard let input = input as? TasksDetailsModuleInput else {
                return nil
            }
            input.configureCurrentModuleWithTask(task: currentTask)
            return nil
        }
    }
}

extension TasksListRouter {
    enum Segue: String {
        case title = "TITLE_SEGUE"
    }
}
