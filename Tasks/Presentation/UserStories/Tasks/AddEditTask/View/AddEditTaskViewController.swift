//
//  AddEditTaskAddEditTaskViewController.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import GrowingTextView
import RxCocoa
import RxSwift
import UIKit

class AddEditTaskViewController: UIViewController {
    var viewModel: AddEditTaskViewModel!

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateStartTextField: UITextField!
    @IBOutlet var dateEndTextField: UITextField!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var toolBarSB: UIToolbar!
    @IBOutlet var datePickerSB: UIDatePicker!
    @IBOutlet var descriptionTextView: GrowingTextView!

    private let bag = DisposeBag()

    // MARK: Life cycle

    // TODO: implement extension to NSObject + diTag in storyboard, or add NSObject to VC in SB
    override func awakeFromNib() {
        super.awakeFromNib()
        AddEditTaskAssembly.instance().inject(into: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        configureViewContoller()
        configureBindings(viewModel: viewModel)
            .disposed(by: bag)
    }

    // MARK: Methods IBActions

    @IBAction func valueChangedDatePicker(_ sender: UIDatePicker) {
        didChangedDateInDatePicker(sender: sender)
    }

    @IBAction func pressedSaveButon(_: UIBarButtonItem) {
        viewModel.didPressedSaveButton()
    }

    @IBAction func actionDoneKeyboardButton(_: UIBarButtonItem) {
        view.endEditing(true)
    }
}

private extension AddEditTaskViewController {
    func configureBindings(viewModel: AddEditTaskViewModel) -> [Disposable] {
        return [
            viewModel.title
                .asDriver()
                .drive(titleTextField.rx.text),

            viewModel.description
                .asDriver()
                .drive(descriptionTextView.rx.text),

            viewModel.navigationTitle
                .asDriver()
                .drive(navigationItem.rx.title),

            viewModel.dateStart
                .asDriver()
                .drive(dateStartTextField.rx.text),

            viewModel.dateEnd
                .asDriver()
                .drive(dateEndTextField.rx.text),

            titleTextField.rx.text
                .orEmpty
                .bind(to: viewModel.title),

            descriptionTextView.rx.text
                .orEmpty
                .bind(to: viewModel.description),

            dateStartTextField.rx.text
                .orEmpty
                .bind(to: viewModel.dateStart),

            dateEndTextField.rx.text
                .orEmpty
                .bind(to: viewModel.dateEnd),

            viewModel
                .errorMessage
                .drive(rx.alertWithTitle),

            viewModel
                .closeVC
                .drive(onNext: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }),
        ]
    }

    func configureViewContoller() {
        customizeKeyboards()
        descriptionTextView.placeHolder = viewModel.placeHolder
    }
}

private extension AddEditTaskViewController {
    func customizeKeyboards() {
        for textField in textFieldCollection {
            textField.inputAccessoryView = toolBarSB
        }
        descriptionTextView.inputAccessoryView = toolBarSB
        dateStartTextField.inputView = datePickerSB
        dateEndTextField.inputView = datePickerSB
    }

    func didChangedDateInDatePicker(sender: UIDatePicker) {
        let date = viewModel.dateToString(date: sender.date)
        for textField in textFieldCollection where textField.isEditing {
            textField.text = date
        }
    }
}
