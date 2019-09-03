//
//  AddEditTaskAddEditTaskViewController.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import GrowingTextView
import UIKit
import ViperMcFlurry

protocol AddEditTaskViewInput: class {
    func didChangedDateInDatePicker(to date: String)
    func loadData(with isCurrentTask: Bool, descriptionTask: String?, title: String, startDate: String, endDate: String)
    func alertWithMessage(message: String)
    var titleTF: String? { get }
    var descriptionTask: String? { get }
    var startDate: String? { get }
    var endDate: String? { get }
}

protocol AddEditTaskViewOutput {
    func viewIsReady()
    func didChangedValueDatePicker(date: Date)
    func didPressedSaveButton()
}

class AddEditTaskViewController: UIViewController, AddEditTaskViewInput {
    var output: AddEditTaskViewOutput!

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateStartTextField: UITextField!
    @IBOutlet var dateEndTextField: UITextField!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var toolBarSB: UIToolbar!
    @IBOutlet var datePickerSB: UIDatePicker!
    @IBOutlet var descriptionTextView: GrowingTextView!
    @IBOutlet var visualStateManager: AddEditTaskVisualStateManager!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: - AddEditTaskViewInput

    var titleTF: String? {
        return titleTextField.text
    }

    var descriptionTask: String? {
        return descriptionTextView.text
    }

    var startDate: String? {
        return dateStartTextField.text
    }

    var endDate: String? {
        return dateEndTextField.text
    }

    func didChangedDateInDatePicker(to date: String) {
        for textField in textFieldCollection where textField.isEditing {
            textField.text = date
        }
    }

    func loadData(
        with isCurrentTask: Bool,
        descriptionTask: String?,
        title: String,
        startDate: String,
        endDate: String
    ) {
        visualStateManager.state = isCurrentTask ? .add : .edit
        descriptionTextView.text = descriptionTask
        titleTextField.text = title
        dateStartTextField.text = startDate
        dateEndTextField.text = endDate
    }

    func alertWithMessage(message: String) {
        showAlert(withTitle: L10n.Alert.Title.error, andMessage: message)
    }

    // MARK: Methods IBActions

    @IBAction func valueChangedDatePicker(_ sender: UIDatePicker) {
        output.didChangedValueDatePicker(date: sender.date)
    }

    @IBAction func pressedSaveButon(_: UIBarButtonItem) {
        output.didPressedSaveButton()
    }
}
