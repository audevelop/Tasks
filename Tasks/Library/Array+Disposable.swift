//
//  Array+Disposable.swift
//  Tasks
//
//  Created by Alexey on 29/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import RxSwift

extension Array where Element == Disposable {
    public func disposed(by bag: DisposeBag) {
        forEach { $0.disposed(by: bag) }
    }
}
