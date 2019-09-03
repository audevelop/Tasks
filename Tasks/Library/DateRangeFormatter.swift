//
//  DateRangeFormatter.swift
//  Tasks
//
//  Created by Alexey on 29/03/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Foundation

protocol DateRangeFormatter {
    func string(from fromDate: Date, to toDate: Date) -> String
}

class DateRangeFormatterImp {
    private var dateFormatterToString: DateToStringProtocol

    init(dateFormatterToString: DateToStringProtocol) {
        self.dateFormatterToString = dateFormatterToString
    }
}

extension DateRangeFormatterImp: DateRangeFormatter {
    func string(from fromDate: Date, to toDate: Date) -> String {
        return dateFormatterToString.string(from: fromDate)
            + " - "
            + dateFormatterToString.string(from: toDate)
    }
}
