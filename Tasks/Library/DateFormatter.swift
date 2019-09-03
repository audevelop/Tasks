//
//  DateFormatter.swift
//  Tasks
//
//  Created by Alexey on 11/09/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation

protocol DateToStringProtocol {
    func string(from date: Date) -> String
}

protocol DateParserProtocol {
    func date(from string: String) -> Date?
}

extension DateFormatter: DateToStringProtocol {}

extension DateFormatter: DateParserProtocol {}
