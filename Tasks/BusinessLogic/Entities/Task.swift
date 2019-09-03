//
//  Task.swift
//  Tasks
//
//  Created by Alexey on 13/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import Swinject
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

extension Task {
    func dictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        let r = ApplicationAssembly.assembler.resolver as! Container
        let dateFormatter = r.resolve(DateFormatter.self, name: FormatterType.articleDateFormatter.rawValue)!
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        guard
            let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(
                with: json,
                options: []
            ) as? [String: Any]
        else {
            return nil
        }
        return dict
    }
}
