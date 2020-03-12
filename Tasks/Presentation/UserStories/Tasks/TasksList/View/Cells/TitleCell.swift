//
//  TitleCell.swift
//  Tasks
//
//  Created by Alexey on 16/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Reusable
import UIKit

class TitleCell: UITableViewCell, Reusable {

    // MARK: - Methods

    func fill(with task: Task) {
        textLabel?.text = task.title
    }
}
