//
//  OctopusKit+Logs.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2018/02/12.
//  Copyright © 2020 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

//  Logs are in a separate extension for convenience, e.g. so that a project may replace them with its own versions.

import OSLog

public extension OKLog {
    
    // MARK: Global Logs
    
    /// A log for core or general engine events.
    static let framework  = Logger(subsystem: OctopusKit.Constants.Strings.octopusKitBundleID, category: "⚙️ Framework")
            
    /// A log for operations that involve loading, downloading, caching and writing game assets and related resources.
    static let resources  = Logger(subsystem: OctopusKit.Constants.Strings.octopusKitBundleID, category: "📦 Resources")
    
    /// A log for deinitializations; when an object is freed from memory.
    static let deinits    = Logger(subsystem: OctopusKit.Constants.Strings.octopusKitBundleID, category: "💀 Deinits")
    
    /// A log for events that may cause unexpected behavior but *do not* prevent continued execution.
    ///
    /// Enabling the `breakpointOnNewEntry` flag will trigger a breakpoint after each new entry, if the `DEBUG` conditional compilation flag is set, allowing you to review the state of the application and resume execution if running within Xcode.
    static let warnings   = Logger(subsystem: OctopusKit.Constants.Strings.octopusKitBundleID, category: "⚠️ Warnings")
    
    /// A log for severe errors that may prevent continued execution. Adding an entry to this log will raise a `fatalError` and terminate the application.
    static let errors     = Logger(subsystem: OctopusKit.Constants.Strings.octopusKitBundleID, category: "🚫 Errors")
    
    /// A log for verbose debugging information.
    static let debug      = Logger(subsystem: OctopusKit.Constants.Strings.octopusKitBundleID, category: "🐞 Debug")
    
    /// A log for developer tips to assist with fixing warnings and errors.
    static let tips       = Logger(subsystem: OctopusKit.Constants.Strings.octopusKitBundleID, category: "💡 Tips")
    
}
