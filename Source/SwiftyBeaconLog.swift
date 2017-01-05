//
//  SwiftyBeaconLog.swift
//  SwiftyBeaconLog
//
//  Created by Dmitry Lavlinskyy on 4/27/16.
//  Copyright © 2016 Skitsko. All rights reserved.
//

import Foundation

public enum LogLevel: CustomStringConvertible {
    
    case verbose
    case debug
    case info
    case warning
    case error
    case severe
    
    public var description: String {
        switch self {
        case .verbose:
            return "Verbose"
        case .debug:
            return "Debug"
        case .info:
            return "Info"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        case .severe:
            return "Severe"
        }
    }
}

public func defaultLog(level: LogLevel, closure: @escaping () -> String?) {
    print("\(level): \(closure() ?? "")")
}

