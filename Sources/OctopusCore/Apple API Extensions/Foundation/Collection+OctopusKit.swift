//
//  Collection+OctopusKit.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2018/05/03.
//  Copyright © 2020 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

import Foundation

public extension Collection {
    
    @inlinable
    func apply<T>(_ transform: (Self) -> T) -> T {
        // CREDIT: Rudolf Adamkovič (salutis)
        // https://forums.swift.org/t/add-function-application-to-swifts-standard-library/12361
        return transform(self)
    }
}

public extension Collection where Index: Comparable {
    
    /// Returns `true` if the collection is not empty and `index` is equal to or greater than `startIndex` and less than `endIndex`.
    @inlinable
    func isValidIndex(_ index: Self.Index) -> Bool {
        return !self.isEmpty
            && index >= self.startIndex
            && index <  self.endIndex
    }
}

// MARK: - Randomization
// Created by ShinryakuTako@invadingoctopus.io on 2017/10/07.

import GameplayKit

public extension Collection where Index == Int {
        
    /// Returns a random element from this array whose index is not in `skippingIndices`.
    ///
    /// If the array is empty or if the list of exclusions prevents any acceptable value within `maximumAttempts`, `nil` is returned.
    ///
    /// If the array has only 1 element, then that is returned without generating any random indices.
    ///
    /// Calls `Int.random(upto:skipping:maximumAttempts:)` which uses `arc4random_uniform()`.
    ///
    /// Can be used with array literals, e.g.: `[4, 8, 16, 42].randomElement(skippingIndices: [0, 1, 2])`
    @inlinable
    func randomElement(skippingIndices exclusions: Set<Int>,
                       maximumAttempts: UInt = 100) -> Element?
    {
        guard self.count > 0 else { return nil }
        guard self.count > 1 else { return self[0] }
        
        if  let randomIndex = Int.randomFromZero(to: self.count,
                                                 skipping: exclusions,
                                                 maximumAttempts: maximumAttempts)
        {
            return self[randomIndex]
        } else {
            return nil
        }
    }
    
}
