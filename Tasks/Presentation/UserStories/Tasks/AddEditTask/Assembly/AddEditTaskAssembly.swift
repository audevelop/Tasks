//
//  AddEditTaskAssembly.swift
//  Tasks
//
//  Created by Alexey on 05/04/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import EasyDi
import Foundation

// swiftformat:disable redundantSelf

final class AddEditTaskAssembly: Assembly {
    private lazy var servicesAssembly: ServicesAssembly = context.assembly()
    private lazy var dateFormattersAssembly: DateFormattersAssembly = context.assembly()

    func inject(into view: AddEditTaskViewController) {
        defineInjection(key: "view", into: view) {
            $0.viewModel = self.viewModel
            return $0
        }
    }

    private var view: AddEditTaskViewController {
        return definePlaceholder()
    }

    var viewModel: AddEditTaskViewModel {
        return define(
            init: AddEditTaskViewModelImp(
                tasksService: self.servicesAssembly.tasksService,
                dateFormatterToString: self.dateFormattersAssembly.dateToStringShort,
                dateFormatterParse: self.dateFormattersAssembly.dateParserShort
            )
        )
    }
}
