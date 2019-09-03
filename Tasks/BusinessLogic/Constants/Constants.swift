//
//  Constants.swift
//  Tasks
//
//  Created by Alexey on 14/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation

enum Constants {
    case production
    case development
}

extension Constants {
    static var current: Constants {
        #if DEBUG
            return .development
        #else
            return .production
        #endif
    }
}

extension Constants {
    var defaultUrlLocalServer: URL {
        switch self {
        case .production:
            return URL(string: "http://localhost:3000")!
        case .development:
            return URL(string: "http://localhost:3000")!
        }
    }

    var tasksFolder: String {
        switch self {
        case .production:
            return "tasks"
        case .development:
            return "tasks"
        }
    }

    var articleDateFormatter: String {
        return "M/d/yy"
    }
}
