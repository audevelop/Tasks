//
//  AddEditTaskViewModel.swift
//  Tasks
//
//  Created by Alexey on 12/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// swiftformat:disable redundantSelf

protocol AddEditTaskViewModel {
    var currentTask: Variable<Task?> { get }
    var placeHolder: String { get }
    var navigationTitle: Variable<String> { get }
    var title: Variable<String> { get }
    var description: Variable<String> { get }
    var dateStart: Variable<String> { get }
    var dateEnd: Variable<String> { get }
    var errorMessage: Driver<String> { get }
    var closeVC: Driver<Void> { get }

    func setTask(task: Task)
    func viewDidLoad()
    func dateToString(date: Date) -> String
    func didPressedSaveButton()
}

class AddEditTaskViewModelImp: AddEditTaskViewModel {
    enum State {
        case add
        case edit
        case uninitialized
    }

    private var dateFormatterToString: DateToStringProtocol
    private var dateFormatterParse: DateParserProtocol
    private var tasksService: TasksServiceProtocol
    private let bag: DisposeBag = .init()
    private let errorMessageRelay: PublishRelay<String> = .init()

    var errorMessage: Driver<String> {
        return errorMessageRelay.asDriver(onErrorJustReturn: "")
    }

    private let closeVCRelay: PublishRelay<Void> = .init()

    var closeVC: Driver<Void> {
        return closeVCRelay.asDriver(onErrorJustReturn: ())
    }

    var currentTask: Variable<Task?> = .init(nil)
    var placeHolder: String = L10n.Taskedit.description

    var navigationTitle: Variable<String> = .init("")
    var dateStart: Variable<String> = .init("")
    var dateEnd: Variable<String> = .init("")
    var title: Variable<String> = .init("")
    var description: Variable<String> = .init("")

    var state: State = .uninitialized {
        didSet {
            switch state {
            case .add:
                navigationTitle.value = L10n.Taskedit.Title.add
                dateStart.value = dateFormatterToString.string(from: Date())
                dateEnd.value = dateFormatterToString.string(from: Date())
            case .edit:
                navigationTitle.value = L10n.Taskedit.Title.edit
                dateStart.value = dateFormatterToString.string(from: currentTask.value?.startDate ?? Date())
                dateEnd.value = dateFormatterToString.string(from: currentTask.value?.endDate ?? Date())
            case .uninitialized:
                navigationTitle.value = ""
            }
        }
    }

    init(
        tasksService: TasksServiceProtocol,
        dateFormatterToString: DateToStringProtocol,
        dateFormatterParse: DateParserProtocol
    ) {
        self.tasksService = tasksService
        self.dateFormatterToString = dateFormatterToString
        self.dateFormatterParse = dateFormatterParse
    }

    func setTask(task: Task) {
        self.currentTask.value = task
    }

    func viewDidLoad() {
        let isCurrentTask = (currentTask.value == nil)

        if currentTask.value == nil {
            currentTask = Variable<Task?>(Task())
        }

        guard let task = currentTask.value else {
            return
        }
        state = isCurrentTask ? .add : .edit

        description.value = task.descriptionTask ?? ""
        title.value = task.title
    }

    func dateToString(date: Date) -> String {
        return dateFormatterToString.string(from: date)
    }

    func didPressedSaveButton() {
        guard let task = currentTask.value else {
            return
        }

        checkTaskForSave(with: task)
            .flatMapCompletable { [weak self] task in
                self?.tasksService.save(task: task) ?? Completable.error(TasksError.wrongValue)
            }.subscribe(
                onCompleted: { [weak self] in
                    self?.closeVCRelay.accept(())
            }) { [weak self] error in
                self?.errorMessageRelay.accept(error.localizedDescription)
            }.disposed(by: bag)
    }
}

private extension AddEditTaskViewModelImp {
    func checkTaskForSave(with currentTask: Task) -> Single<Task> {
        return Single.create(subscribe: { [weak self] single -> Disposable in

            let disposable = Disposables.create()

            let titleTF = self?.title.value ?? ""
            let charsCount = titleTF.count
            guard charsCount > 0 else {
                single(.error(TasksError.empty))
                return disposable
            }
            guard
                let dateStart = self?.dateStart.value,
                let dateEnd = self?.dateEnd.value
            else {
                single(.error(TasksError.empty))
                return disposable
            }
            guard
                let startDate = self?.dateFormatterParse.date(from: dateStart),
                let endDate = self?.dateFormatterParse.date(from: dateEnd)
            else {
                single(.error(TasksError.wrongValue))
                return disposable
            }
            var task = currentTask
            task.title = titleTF
            if self?.description.value == L10n.Taskedit.description {
                task.descriptionTask = ""
            } else {
                task.descriptionTask = self?.description.value
            }
            task.startDate = startDate
            task.endDate = endDate

            single(.success(task))
            return disposable
        })
    }
}
