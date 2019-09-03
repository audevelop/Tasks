//
//  ServiceComponentsAssembly.swift
//  Tasks
//
//  Created by Alexey on 14/08/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Alamofire
import Foundation
import Swinject

enum FormatterType: String {
    case taskDateFormatter
    case taskDateFormatterShort
    case taskDateParser
    case articleDateFormatter
}

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TasksServiceProtocol.self) { r in
            TasksServiceImp(tasksRepository: r.resolve(NetworkPepository.self)!)
        }.inObjectScope(.transient)
    }
}

final class GatewaysAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkPepository.self) { r in
            NetworkPepositoryImp(
                sessionManager: SessionManager.default,
                decoder: r.resolve(JSONDecoder.self, name: FormatterType.articleDateFormatter.rawValue)!
            )
        }.inObjectScope(.transient)
    }
}

final class InfrastructureAssembly: Assembly {
    func assemble(container: Container) {
        container.register(JSONDecoder.self, name: FormatterType.articleDateFormatter.rawValue) { r in
            let decoder = JSONDecoder()
            let dateFormatter = r.resolve(DateFormatter.self, name: FormatterType.articleDateFormatter.rawValue)!
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            return decoder
        }.inObjectScope(.transient)
    }
}

final class DateFormattersAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DateFormatter.self) { _ in
            let dateFormatter = DateFormatter()
            return dateFormatter
        }.inObjectScope(.transient)

        container.register(DateFormatter.self, name: FormatterType.articleDateFormatter.rawValue) { r in
            let dateFormatter = r.resolve(DateFormatter.self)!
            dateFormatter.dateFormat = Constants.current.articleDateFormatter
            return dateFormatter
        }

        container.register(DateToStringProtocol.self, name: FormatterType.taskDateFormatter.rawValue) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            return dateFormatter
        }

        container.register(DateToStringProtocol.self, name: FormatterType.taskDateFormatterShort.rawValue) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            return dateFormatter
        }

        container.register(DateParserProtocol.self, name: FormatterType.taskDateParser.rawValue) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            return dateFormatter
        }

        container.register(DateRangeFormatter.self) { (_, dateFormatterToString: DateToStringProtocol) in
            let dateRangeFormatter = DateRangeFormatterImp(dateFormatterToString: dateFormatterToString)
            return dateRangeFormatter
        }
    }
}
