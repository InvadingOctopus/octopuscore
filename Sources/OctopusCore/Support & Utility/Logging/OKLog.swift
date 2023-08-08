//
//  OKLog.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2023-07-05
//  Copyright © 2023 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

/// ❕ NOTE: Logging: Goals:
/// * Use the modern Swift structured logging with `Logger` from `OSLog`: This will add metadata and filtering to the Xcode Debug Console.
/// * Add the current frame of the scene to each log entry/line.
/// * Allow the Xcode Debug Console to include a link to the exact file and line of code which generated the log entry.
///
/// Problems:
/// * To append the current frame to each log message, the obvious solution would be to write a custom logging function, which forwards the text to `OSLog.Logger`. However, this will cause the Xcode Debug Console to think that all log messages originate from our custom logging function, instead of the actual originating file. That would defeat a key feature of `OSLog.Logger`.
///
/// Solutions are currently under experimentation, like the `📜` global function to interpolate each log string in every call to `OSLog.Logger`.

/// 💡 SEE ALSO: `debugLog(...)` in `OctopusKit+Global.swift`

import OSLog

public typealias OctopusLog = OKLog

/// Prefix the current frame of the scene to the provided string. This is a temporary workaround to allow `OSLog.Logger` to include a link to the file and line which generates a log entry, by interpolating the string of each log message, instead of calling a custom logging function, which would cause all logging entries to be shown as originating from the custom logging function.
@inlinable
public func 📜(_ text: String) -> String {
    // TODO: Find a better solution :)
    // CHECK: Update `OKLog.lastFrameLogged`?
    return "\(OKLog.currentFrame) \(text)" // TODO: Pad frame counter digits
}

/// An object that contains static properties for tracking and formatting log messages.
public struct OKLog {
    
    // MARK: - Global Settings
    
    /// If `true` then an empty line is printed between each entry in the debug console.
    public static var printEmptyLineBetweenEntries: Bool = false
    
    /// If `true` then an empty line is printed between entries with different frame counts (e.g. F0 and F1).
    public static var printEmptyLineBetweenFrames:  Bool = false
    
    /// If `true` then an entry is printed on at least 2 lines in the debug console, where the time and calling file is on the first line and the text is on the second line.
    public static var printTextOnSecondLine: Bool = false
    
    /// If `true` then debug console output is printed in CSV format, that may then be copied into a spreadsheet table such as Numbers etc.
    ///
    /// See the `OKEntry.csv` property for a list of the values i.e. columns.
    public static var printAsCSV: Bool = false
    
    /// The separator to print between values when `printAsCSV` is `true`. Default: `tab`
    public static var csvDelimiter: String = "\t"
    
    // MARK: Padding
    // DESIGN: PERFORMANCE: Making them `let` instead of `var` may be faster.
    
    // The number of characters to trim or pad the frame number to when printing entries.
    public static let frameLength:  Int = 8
    
    // The number of characters to trim or pad the prefix to when printing entries.
    public static let prefixLength: Int = 8
    
    // The number of characters to trim or pad the topic to when printing entries.
    public static let topicLength:  Int = 35
    
    // MARK: Static Properties
    
    /// Stores the frame number during the most recent log entry, so we can mark the beginning of a new frame to make logs easier to read.
    public static var lastFrameLogged: UInt64 = 0 // Not fileprivate(set) so functions can be @inlinable
    
    /// Returns the `currentFrameNumber` of `OctopusKit.shared.currentScene`, if available, otherwise `0`.
    @inlinable
    public static var currentFrame: UInt64 {
        // ⚠️ Trying to access `OctopusKit.shared.currentScene` at the very beginning of the application results in an exception like "Simultaneous accesses to 0x100e8f748, but modification requires exclusive access", so we delay it by checking something like `gameCoordinator.didEnterInitialState`
        
#if OCTOPUSKIT
        if  OctopusKit.shared?.gameCoordinator.didEnterInitialState ?? false {
            return OctopusKit.shared.currentScene?.currentFrameNumber ?? 0
        } else {
            return 0
        }
#else
        // PLACEHOLDER: Removed in OctopusCore: Cannot have support for frame-counting without a game rendering framework.
        return 0
#endif
        
    }
    
    /// Returns `true` if the `currentFrame` count is higher than `lastFrameLogged`.
    @inlinable
    public static var isNewFrame: Bool {
        self.currentFrame > self.lastFrameLogged
    }
    
    // MARK: - Formatting
    
    /// The global time formatter for all OctopusKit logging functions.
    ///
    /// To customize the `dateFormat` property, see the Unicode Technical Standard #35 version tr35-31: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
    public static let timeFormatter: DateFormatter = {
        let timeFormatter           = DateFormatter()
        timeFormatter.locale        = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat    = "HH:mm:ss"
        return timeFormatter
    }()
    
    /// Returns a string with the specified time as formatted by the global `OKLog.timeFormatter`.
    @inlinable
    public static func formattedTimeString(time: Date) -> String {
        // TODO: A better way to get nanoseconds like `NSLog`
        
        let nanoseconds = "\(Calendar.current.component(.nanosecond, from: time))".prefix(6)
        let time        = OKLog.timeFormatter.string(from: time)
        
        let timeWithNanoseconds = "\(time).\(nanoseconds)"
        
        return timeWithNanoseconds
    }
    
    /// Returns a string with the current time as formatted by the global `OKLog.timeFormatter`.
    @inlinable
    public static func currentTimeString() -> String {
        formattedTimeString(time: Date())
    }
    
    /// Returns a string with the number of the frame being rendered by the current scene, if any.
    @inlinable
    public static func currentFrameString() -> String {
        
        let currentFrame = self.currentFrame // PERFORMANCE: Don't query the scene repeatedly via properties.
        
        /// If the `lastFrameLogged` is higher than the `currentFrame`, then it may mean the active scene has changed and we should reset the last-frame counter.
        
        if  self.lastFrameLogged > currentFrame {
            self.lastFrameLogged = 0
        }
        
        let isNewFrame = (currentFrame > self.lastFrameLogged) // PERFORMANCE: Again, don't query the properties.
        
        if  printEmptyLineBetweenFrames && isNewFrame {
            // CHECK: Should this be the job of the time function?
            print("")
        }
        
        let currentFrameNumberString = " F" + "\(currentFrame)".paddedWithSpace(toLength: frameLength) + "\(isNewFrame ? "•" : " ")"
        
        /// BUG FIXED: Set `lastFrameLogged` in `OKLog.add(...)` instead of here, so that `OKLogEntry.init(...)` has a chance to check `isNewFrame` correctly.
        
        return currentFrameNumberString
    }
    
    /// Returns a string with the current time formatted by the global `OKLog.timeFormatter` and the number of the frame being rendered by the current scene, if any.
    @inlinable
    public static func currentTimeAndFrame() -> String {
        currentTimeString() + currentFrameString()
    }
    
    // MARK: - Instance Properties
        
    /// If `true` then a breakpoint is triggered after a new entry is added. Ignored if the `DEBUG` conditional compilation flag is not set.
    ///
    /// Calls `raise(SIGINT)`. Useful for logs that display warnings or other events which may cause incorrect or undesired behavior. Application execution may be resumed if running within Xcode.
    public var breakpointOnNewEntry: Bool = false
    
    /// If `true` then a `fatalError` is raised after a new entry is added.
    ///
    /// Useful for logs which display critical errors.
    public var haltApplicationOnNewEntry: Bool = false
    
}
