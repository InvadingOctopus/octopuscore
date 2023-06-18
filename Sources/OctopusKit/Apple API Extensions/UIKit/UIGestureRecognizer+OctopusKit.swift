//
//  UIGestureRecognizer+OctopusKit.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2018/04/19.
//  Copyright © 2020 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

#if canImport(UIKit)

import UIKit

public extension UIGestureRecognizer {
    
    /// Specifies whether the recognizer is currently processing a gesture.
    ///
    /// Returns `true` when the gesture recognizer's `state` is `.began` or `.changed`.
    ///
    /// Returns `false` when the `state` is `.possible`, `.cancelled`, `.failed` or `.ended`.
    ///
    /// Use this flag to avoid unnecessary processing in gesture-controlled objects.
    @inlinable
    var isHandlingGesture: Bool {
        switch self.state {
            // CHECK: Is this all the correct states?
            
        case .began, .changed: // CHECK: Should this include `.ended?`
            return true
            
        case .possible, .cancelled, .failed, .ended:
            return false

        @unknown default:
            return false // CHECK: Is this the correct way to handle this, or 'fatalError()'?
        }
    }
}

#endif
