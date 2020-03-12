//
//  GatewaysAssembly.swift
//  Tasks
//
//  Created by Alexey on 29/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import EasyDi
import Foundation
import RealmSwift

// swiftformat:disable redundantSelf

final class GatewaysAssembly: Assembly {
    private lazy var infrastructureAssembly: InfrastructureAssembly = context.assembly()

    var networkGateway: TasksGateway {
        return define(init: TasksGatewayImp(
            baseUrl: Constants.current.defaultUrlLocalServer,
            sessionManager: self.infrastructureAssembly.sessionManager,
            decoder: self.infrastructureAssembly.decoder,
            encoder: self.infrastructureAssembly.encoder)
        )
    }

    var persistenceGateway: PersistenceGateway {
        return define(
            scope: .lazySingleton,
            init: PersistenceGatewayImp(configuration: self.realmConfig)
        )
    }

    var realmConfig = Realm.Configuration(
        schemaVersion: 0,
        deleteRealmIfMigrationNeeded: true
    )
}
