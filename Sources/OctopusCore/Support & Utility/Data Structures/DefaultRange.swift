//
//  DefaultRange.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2023/08/04.
//  Copyright © 2023 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

import Foundation

/// A structure representing the default, minimum and maximum values for a property. The minimum and maximum values are included in the valid range.
///
/// This may be used in cases like UI that displays the initial value and limits the allowed range for a property that may be set by the user or player, such as the size of a scene.
public struct DefaultRange<T: Comparable> {
    public let initial: T
    public let minimum: T
    public let maximum: T
    
    /// A `ClosedRange` that includes the `minimum` and `maximum`.
    public let range: ClosedRange<T>
    
    /// Create a `DefaultRange` representing the valid range of values for an external property, such as the size of a scene.
    ///
    /// - Parameters:
    ///   - initial: The first default value, which must be equal to or between `minimum` and `maximum`.
    ///
    /// - NOTE: The minimum (lower bound) and maximum (upper bound) of the range are assumed to be **included** within the valid values represented by this structure.
    public init(initial: T, range: ClosedRange<T>) {
        
        // NOTE: We don't include an init that lets the user set the `minimum` and `maximum` because a Swift `ClosedRange` probably offers more checking at compile time. :)
        
        self.range   = range
        self.minimum = range.lowerBound
        self.maximum = range.upperBound
        
        assert(minimum < maximum, "The `minimum` value is not less than the `maximum`")
        assert(initial >= minimum && initial <= maximum, "The `initial` value is outside the `minimum` and `maximum`")
        
        self.initial = initial
    }
}
