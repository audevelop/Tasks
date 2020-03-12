//
//  InfrastructureAssembly.swift
//  Tasks
//
//  Created by Alexey on 29/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Alamofire
import EasyDi
import Foundation

// swiftformat:disable redundantSelf

final class InfrastructureAssembly: Assembly {
    private lazy var dateFormattersAssembly: DateFormattersAssembly = context.assembly()

    var decoder: JSONDecoder {
        return define(init: JSONDecoder()) {
            $0.dateDecodingStrategy = .formatted(self.dateFormattersAssembly.dateFormatterArticle)
            return $0
        }
    }

    var encoder: JSONEncoder {
        return define(init: JSONEncoder()) {
            $0.dateEncodingStrategy = .formatted(self.dateFormattersAssembly.dateFormatterArticle)
            return $0
        }
    }

    var sessionManager: SessionManager {
        return define(init: SessionManager.default)
    }
}
