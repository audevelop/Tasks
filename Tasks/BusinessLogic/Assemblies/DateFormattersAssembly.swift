//
//  DateFormattersAssembly.swift
//  Tasks
//
//  Created by Alexey on 29/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import EasyDi
import Foundation

// swiftformat:disable redundantSelf

final class DateFormattersAssembly: Assembly {
    var dateFormatter: DateFormatter {
        return define(init: DateFormatter())
    }

    var dateFormatterArticle: DateFormatter {
        return define(init: self.dateFormatter) {
            $0.dateFormat = Constants.current.articleDateFormatter
            return $0
        }
    }

    var dateToStringLong: DateToStringProtocol {
        return define(init: self.dateFormatter) {
            $0.dateStyle = .long
            return $0
        }
    }

    var dateToStringShort: DateToStringProtocol {
        return define(init: self.dateFormatter) {
            $0.dateStyle = .short
            return $0
        }
    }

    var dateParserShort: DateParserProtocol {
        return define(init: self.dateFormatter) {
            $0.dateStyle = .short
            return $0
        }
    }

    var dateRangeFormatter: DateRangeFormatter {
        return define(init: DateRangeFormatterImp(dateFormatterToString: self.dateToStringShort))
    }
}
