//
//  OKUserDefaults.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2014/10/31.
//  Copyright © 2020 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

// TODO: Review, improve and test
// TODO: Reevaluate names according to Swift API guidelines.

import Foundation
import OSLog

public typealias OctopusUserDefault = OKUserDefault

/// Represents a key and value pair saved in `UserDefaults.standard`, for storing user preferences and settings, as well as providing a default value if a key has not been saved.
///
/// - IMPORTANT: The type of the value must be a type that can be saved in property lists.
///
/// 💡 **Tip:** Use the `TypeSafeIdentifiers` protocol for eliminating typos and other mistakes when passing around string keys.
@propertyWrapper public struct OKUserDefault <ValueType> : CustomStringConvertible {
    
    // NOTE: This is "ValueType" as in type of the value, not "value type" as in structs or enums. :)
    
    public let key: String
    public let defaultValue: ValueType
    
    /// Creates a representation of a user preference and registers the default value for the specified key in `UserDefaults.standard`.
    ///
    /// The preference may be retrieved by accessing the `value` property of this object, or any of the `UserDefaults.standard.object(forKey:)` series of functions.
    public init(key: String, defaultValue: ValueType) {
       
        self.key = key
        self.defaultValue = defaultValue
        
        // Register the default value to also make it accessible via any of the `UserDefaults.standard.object(forKey:)` series of functions.
        UserDefaults.standard.register(defaults: [key: defaultValue])
    }
    
    /// Sets the value for `key` in `UserDefaults.standard`, or gets the value if `key` exists in `UserDefaults.standard`, otherwise returns `defaultValue`.
    @inlinable
    public var wrappedValue: ValueType {
        
        // CHECK: Add caching to avoid accessing UserDefaults every frame?
        
        get {
            if  let value = UserDefaults.standard.object(forKey: key) as? ValueType {
                // OKLog.logForDebug("\"\(key)\" \(ValueType.self) = \(value)") // ❕ May spam the log when this is accessed every frame.
                return value
            } else {
                OKLog.logForDebug.debug("\(📜("\"\(key)\" \(ValueType.self) not found, defaultValue = \(defaultValue) ❗️"))")
                return defaultValue
            }
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            // UserDefaults.standard.synchronize() // Not needed as of 2018-02?
            // http://www.codingexplorer.com/nsuserdefaults-a-swift-introduction/
        }
    }
    
    @inlinable
    public var description: String {
        "UserDefault \"\(key)\" \(ValueType.self): \(wrappedValue)"
    }

    // MARK: - Static Functions
        
    /// - Returns: The user default (preference/setting) for `key` if `key` exists in `UserDefaults.standard` and matches the specified `ValueType`, otherwise `nil`.
    ///
    /// This function may be chained with the `??` operator to provide a [different] default value at each call site.
    @inlinable
    public static func preference(forKey key: String) -> ValueType? {
        // CHECK: `preference<T>` removed for Swift 6 conformance; should it be brought back?
        if  let value = UserDefaults.standard.object(forKey: key) as? ValueType {
            OKLog.logForDebug.debug("\(📜("\"\(key)\" \(ValueType.self) = \(value)"))")
            return value
        } else {
            OKLog.logForDebug.debug("\(📜("\"\(key)\" \(ValueType.self) not found ❗️"))")
            return nil
        }
    }
    
    @discardableResult public static func registerDefaultPreferencesFromPropertyList(named plistName: String = "UserDefaults") -> Bool {
        
        // TODO: Update for Swift 5.1
        // TODO: Proper error handling.
        
        // NOTE: It seems best to call this from `NSApplicationDelegate.applicationWillFinishLaunching(_:)`, not `...DidFinishLaunching`, at least in an `NSDocument`-based app..
        
        OKLog.logForFramework.debug("\(📜("plistName: \(plistName)"))")
        
        guard
            let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
            let defaultsDictionary = NSDictionary(contentsOfFile: path) as? [String: Any] // TODO: Use idiomatic Swift
            else { return false }
        
        UserDefaults.standard.register(defaults: defaultsDictionary)
        return true
    }
    
}
