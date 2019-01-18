//
//  Observable.swift
//  BackgroundVideo
//
//  Created by Deepak Kumar on 17/01/19.
//  Copyright © 2019 deepak. All rights reserved.
//

import Foundation

public class Observable<ObservedType> {
    public typealias Observer = (_ observable: Observable<ObservedType>, ObservedType) -> Void

    private var observers: [Observer]

    public var value: ObservedType? {
        didSet {
            if let value = value {
                notifyObservers(value)
            }
        }
    }

    public init(_ value: ObservedType? = nil) {
        self.value = value
        observers = []
    }

    public func bind(observer: @escaping Observer) {
        self.observers.append(observer)
    }

    private func notifyObservers(_ value: ObservedType) {
        self.observers.forEach { [unowned self] (observer) in
            observer(self, value)
        }
    }
}
