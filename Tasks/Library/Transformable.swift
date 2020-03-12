//
//  Transformable.swift
//  Tasks
//
//  Created by Alexey on 30/05/2019.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Foundation
import RealmSwift

public protocol ManagedTransformable {
    associatedtype ManagedType: Object, PlainTransformable where ManagedType.PlainType == Self
    var managedObject: ManagedType { get }

    init(managed object: ManagedType)
}

public protocol PlainTransformable {
    associatedtype PlainType: ManagedTransformable where PlainType.ManagedType == Self

    var plainObject: PlainType { get }

    init(plain object: PlainType)

    @discardableResult
    func set(with plain: PlainType) -> Self
}

public extension ManagedTransformable {
    init(required object: ManagedType?) {
        guard let obj = object else {
            fatalError("Required object not found")
        }
        self.init(managed: obj)
    }

    init?(optional object: ManagedType?) {
        guard let obj = object else {
            return nil
        }
        self.init(managed: obj)
    }
}

public extension RawRepresentable {
    init(required object: RawValue) {
        guard let decoded = Self(rawValue: object) else {
            fatalError("Failed to decode raw value")
        }

        self = decoded
    }
}
