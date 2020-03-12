//
//  Task.swift
//  Tasks
//
//  Created by Alexey on 13/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

// import Swinject
import EasyDi
import Foundation
import UIKit

struct Task: Codable {
    var title: String
    var descriptionTask: String?
    var startDate: Date
    var endDate: Date
    var taskId: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case descriptionTask = "description"
        case startDate
        case endDate
        case taskId = "id"
    }

    init() {
        title = ""
        descriptionTask = ""
        startDate = Date()
        endDate = Date()
    }
}
