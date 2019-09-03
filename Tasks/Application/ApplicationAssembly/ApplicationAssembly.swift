//
//  ApplicationAssembly.swift
//  Tasks
//
//  Created by Alexey on 14/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class ApplicationAssembly {
    static var assembler: Assembler {
        return Assembler([
            ServicesAssembly(),
            GatewaysAssembly(),
            InfrastructureAssembly(),
            DateFormattersAssembly(),
            TasksListModuleAssemblyContainer(),
            TasksDetailsModuleAssemblyContainer(),
            AddEditTaskModuleAssemblyContainer(),
        ])
    }

    var assembler: Assembler

    // If you want use custom Assembler
    init(with assemblies: [Assembly]) {
        assembler = Assembler(assemblies)
    }
}

// Inject dependencies in Main Storyboard
extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer = ApplicationAssembly.assembler.resolver as! Container
    }
}
