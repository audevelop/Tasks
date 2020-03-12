//
//  ServicesAssembly.swift
//  Tasks
//
//  Created by Alexey on 04/04/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import EasyDi

// swiftformat:disable redundantSelf

final class ServicesAssembly: Assembly {
    private lazy var gatewaysAssembly: GatewaysAssembly = context.assembly()

    var tasksService: TasksServiceProtocol {
        return define(
            init: TasksServiceImp(
                tasksRepository: self.gatewaysAssembly.networkGateway,
                persistenceGateway: self.gatewaysAssembly.persistenceGateway)
        )
    }
}
