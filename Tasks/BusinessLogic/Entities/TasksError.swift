//
//  TasksError.swift
//  Tasks
//
//  Created by Alexey on 14/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation

protocol LocalizedRawError: RawRepresentable, LocalizedError {}

enum TasksError: String, LocalizedRawError {
    case empty
    case wrongValue
    case outOfValue
}

extension LocalizedRawError where RawValue == String {
    var errorDescription: String? {
        return NSLocalizedString("\(Self.self).\(rawValue)", comment: "")
    }
}
