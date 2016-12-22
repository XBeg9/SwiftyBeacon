//
//  SwiftyBeaconLog.swift
//  SwiftyBeaconLog
//
//  Created by Dmitry Lavlinskyy on 4/27/16.
//  Copyright © 2016 Skitsko. All rights reserved.
//

import Foundation

public protocol SwiftyBeaconLogger {
    
    func verbose(functionName: String, fileName: String, lineNumber: Int, closure: @noescape () -> String?)
    func debug(functionName: String, fileName: String, lineNumber: Int, closure: @noescape () -> String?)
    func info(functionName: String, fileName: String, lineNumber: Int, closure: @noescape () -> String?)
    func warning(functionName: String, fileName: String, lineNumber: Int, closure: @noescape () -> String?)
    func error(functionName: String, fileName: String, lineNumber: Int, closure: @noescape () -> String?)
    func severe(functionName: String, fileName: String, lineNumber: Int, closure: @noescape () -> String?)
}

internal class SwiftyBeaconLogManager {
    
    var logger: SwiftyBeaconLogger?
    
    func verbose(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, closure: @noescape () -> String?) {

        logger?.verbose(functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func debug(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, closure: @noescape () -> String?) {
        logger?.debug(functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func info(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, closure: @noescape () -> String?) {
        
        logger?.info(functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func warning(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, closure: @noescape () -> String?) {
        
        logger?.warning(functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func error(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, closure: @noescape () -> String?) {
        
        logger?.error(functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func severe(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, closure: @noescape () -> String?) {
        
        logger?.severe(functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
}
