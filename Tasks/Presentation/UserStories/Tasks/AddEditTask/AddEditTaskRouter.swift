//
//  AddEditTaskAddEditTaskRouter.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import ViperMcFlurry

protocol AddEditTaskRouterInput: class {
    func close()
}

class AddEditTaskRouter: AddEditTaskRouterInput {
    weak var transitionHandler: RamblerViperModuleTransitionHandlerProtocol?

    func close() {
        transitionHandler?.closeCurrentModule!(true)
    }
}
