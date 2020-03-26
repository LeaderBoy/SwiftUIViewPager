//
//  Buildable.swift
//  SwiftUIViewPager
//
//  Created by 杨 on 2020/3/26.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation
/// https://github.com/fermoya/SwiftUIPager/blob/master/Sources/SwiftUIPager/Helpers/Buildable.swift
/// Adds a helper function to mutate a properties and help implement _Builder_ pattern
protocol Buildable { }

extension Buildable {

    /// Mutates a property of the instance
    ///
    /// - Parameter keyPath:    `WritableKeyPath` to the instance property to be modified
    /// - Parameter value:      value to overwrite the  instance property
    public func mutating<T>(keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }

}
