//
//  TasksDetailsTasksDetailsRouter.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import ViperMcFlurry

protocol TasksDetailsRouterInput {
    func passDataToNextScene(currentTask: Task)
}

class TasksDetailsRouter {
    weak var transitionHandler: RamblerViperModuleTransitionHandlerProtocol?
}

extension TasksDetailsRouter: TasksDetailsRouterInput {
    func passDataToNextScene(currentTask: Task) {
        transitionHandler?.openModule!(usingSegue: StoryboardSegue.Main.fromTitleToTask.rawValue).thenChain { input in
            guard let input = input as? AddEditTaskModuleInput else {
                return nil
            }
            input.configureCurrentModuleWithTask(task: currentTask)
            return nil
        }
    }
}
