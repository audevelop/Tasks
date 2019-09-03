//
//  AddEditTaskVisualStateManager.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import UIKit

class AddEditTaskVisualStateManager: NSObject {
    var dateFormatterToString: DateToStringProtocol?

    enum State {
        case add
        case edit
        case uninitialized
    }

    @IBOutlet var controller: AddEditTaskViewController!

    var state: State = .uninitialized {
        didSet {
            initOnceNotifications()
            controller.descriptionTextView.placeHolder = L10n.TaskEdit.description
            switch state {
            case .add:
                controller.navigationItem.title = L10n.TaskEdit.Title.add
                controller.dateStartTextField.text = dateFormatterToString?.string(from: Date())
                controller.dateEndTextField.text = dateFormatterToString?.string(from: Date())
            case .edit:
                controller.navigationItem.title = L10n.TaskEdit.Title.edit
            case .uninitialized:
                controller.navigationItem.title = ""
            }
        }
    }

    // MARK: Methods

    @IBAction func actionDoneKeyboardButton(_: UIBarButtonItem) {
        controller.view.endEditing(true)
    }

    private lazy var performOnce: Void = {
        customizeKeyboards()
    }()

    func initOnceNotifications() {
        _ = performOnce
    }

    func customizeKeyboards() {
        for textField in controller.textFieldCollection {
            textField.inputAccessoryView = controller.toolBarSB
        }
        controller.descriptionTextView.inputAccessoryView = controller.toolBarSB
        controller.dateStartTextField.inputView = controller.datePickerSB
        controller.dateEndTextField.inputView = controller.datePickerSB
    }
}
