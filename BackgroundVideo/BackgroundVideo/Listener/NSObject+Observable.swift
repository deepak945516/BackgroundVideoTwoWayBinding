//
//  NSObject+Observable.swift
//  BackgroundVideo
//
//  Created by Deepak Kumar on 17/01/19.
//  Copyright © 2019 deepak. All rights reserved.
//

import Foundation

extension NSObject {
    public func observe<T>(for observable: Observable<T>, with: @escaping (T) -> ()) {
        observable.bind { observable, value  in
            DispatchQueue.main.async {
                with(value)
            }
        }
    }
}
