//
//  ExtensionViewController.swift
//  Tasks
//
//  Created by Alexey on 15/11/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension UIViewController {
    private func showInformationAlertWith(
        title: String,
        message: String,
        firstButtonTitle: String? = "ОК",
        andActionForFirstButtonHandler: ((UIAlertAction) -> Void)?,
        secondButtonTitle: String? = nil,
        andSecondAction: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.view.tintColor = .black

        alert.createTitleAttribString(title: title)

        alert.createMessageAttribString(message: message)

        alert.createFirstAction(
            firstButtonTitle: firstButtonTitle,
            andActionForFirstButtonHandler: andActionForFirstButtonHandler
        )

        alert.createSecondAction(
            secondButtonTitle: secondButtonTitle,
            andSecondAction: andSecondAction
        )

        present(alert, animated: true, completion: nil)
    }

    func showAlert(withTitle: String, andMessage: String) {
        showInformationAlertWith(
            title: withTitle,
            message: andMessage,
            andActionForFirstButtonHandler: nil
    ) }

    func showAlert(withError: Error) {
        showAlert(withTitle: withError.localizedDescription, andMessage: "")
    }

    func showAlert(withMessage: String) {
        showAlert(withTitle: withMessage, andMessage: "")
    }
}

extension UIAlertController {
    func createMessageAttribString(message: String) {
        let font2 = UIFont.systemFont(ofSize: 14)

        let attribMessage = NSAttributedString(
            string: message,
            attributes: [.kern: 1.0, NSAttributedString.Key.font: font2]
        )

        setValue(
            attribMessage,
            forKey: "attributedMessage"
        )
    }

    func createTitleAttribString(title: String) {
        let font1 = UIFont.systemFont(ofSize: 15)

        let attribTitle = NSAttributedString(
            string: title,
            attributes: [.kern: 1.0, NSAttributedString.Key.font: font1]
        )

        setValue(attribTitle, forKey: "attributedTitle")
    }

    func createFirstAction(
        firstButtonTitle: String?,
        andActionForFirstButtonHandler: ((UIAlertAction) -> Void)?
    ) {
        var title = "ОК"
        if let bt = firstButtonTitle {
            title = bt
        }

        if let actionHandler = andActionForFirstButtonHandler {
            let action = UIAlertAction(
                title: firstButtonTitle,
                style: .default,
                handler: actionHandler
            )
            addAction(action)
        } else {
            let emptyAction = UIAlertAction(
                title: title,
                style: .default,
                handler: nil
            )
            addAction(emptyAction)
        }
    }

    func createSecondAction(
        secondButtonTitle: String?,
        andSecondAction: ((UIAlertAction) -> Void)?
    ) {
        if let secondActionHandler = andSecondAction {
            let action = UIAlertAction(
                title: secondButtonTitle,
                style: .cancel,
                handler: secondActionHandler
            )
            addAction(action)
        } else if secondButtonTitle != nil {
            let action = UIAlertAction(
                title: secondButtonTitle,
                style: .cancel,
                handler: nil
            )
            addAction(action)
        }
    }
}

extension Reactive where Base: UIViewController {
    var alertWithTitle: Binder<String> {
        return Binder(base) { view, message in
            view.showAlert(withTitle: L10n.Alert.Title.error, andMessage: message)
        }
    }
}
