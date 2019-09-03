//
//  AddEditTaskAddEditTaskPresenter.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import PromiseKit
import ViperMcFlurry

protocol AddEditTaskModuleInput: class, RamblerViperModuleInput {
    func configureCurrentModuleWithTask(task: Task)
}

class AddEditTaskPresenter: NSObject {
    weak var view: AddEditTaskViewInput?
    var router: AddEditTaskRouterInput?
    var dateFormatterToString: DateToStringProtocol?
    var dateFormatterParse: DateParserProtocol?
    var currentTask: Task?
    var tasksService: TasksServiceProtocol!

    // MARK: Interactor methods

    func saveTask(task: Task) -> Promise<Data> {
        return tasksService.save(task: task)
    }
}

extension AddEditTaskPresenter: AddEditTaskViewOutput {
    func viewIsReady() {
        let isCurrentTask = (currentTask == nil)
        currentTask = currentTask ?? Task()
        guard let task = currentTask else {
            return
        }
        let descriptionTask = task.descriptionTask ?? nil
        let title = task.title
        guard
            let startDate = dateFormatterToString?.string(from: task.startDate),
            let endDate = dateFormatterToString?.string(from: task.endDate)
        else {
            return
        }
        view?.loadData(with: isCurrentTask,
                       descriptionTask: descriptionTask,
                       title: title,
                       startDate: startDate,
                       endDate: endDate)
    }

    func didChangedValueDatePicker(date: Date) {
        guard let strDate = dateFormatterToString?.string(from: date) else {
            return
        }
        view?.didChangedDateInDatePicker(to: strDate)
    }

    func didPressedSaveButton() {
        guard let task = currentTask else {
            return
        }
        firstly {
            self.checkTaskForSave(with: task)
        }.then { task in
            self.saveTask(task: task)
        }.done { _ in
            self.router?.close()
        }.catch { error in
            self.view?.alertWithMessage(message: error.localizedDescription)
        }
    }

    // MARK: - Private methods

    func checkTaskForSave(with currentTask: Task) -> Promise<Task> {
        return firstly { () -> Promise<Task> in
            //
            let titleTF = self.view?.titleTF ?? ""
            let charsCount = titleTF.count
            guard charsCount > 0 else {
                throw TasksError.empty
            }

            guard
                let dateStart = self.view?.startDate,
                let dateEnd = self.view?.endDate
            else {
                throw TasksError.empty
            }
            guard
                let startDate = dateFormatterParse?.date(from: dateStart),
                let endDate = dateFormatterParse?.date(from: dateEnd)
            else {
                throw TasksError.wrongValue
            }
            var task = currentTask
            task.title = titleTF
            if self.view?.descriptionTask == L10n.TaskEdit.description {
                task.descriptionTask = ""
            } else {
                task.descriptionTask = self.view?.descriptionTask
            }
            task.startDate = startDate
            task.endDate = endDate

            return .value(task)
        }
    }
}

extension AddEditTaskPresenter: AddEditTaskModuleInput {
    func configureCurrentModuleWithTask(task: Task) {
        currentTask = task
    }
}
