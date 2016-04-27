//
//  SwiftyBeaconLog.swift
//  SwiftyBeaconLog
//
//  Created by Dmitry Lavlinskyy on 4/27/16.
//  Copyright © 2016 Skitsko. All rights reserved.
//

import Foundation

public protocol Logger {
    
    func verbose(functionName: String, fileName: String, lineNumber: Int, @noescape closure: () -> String?)
    func debug(functionName: String, fileName: String, lineNumber: Int, @noescape closure: () -> String?)
    func info(functionName: String, fileName: String, lineNumber: Int, @noescape closure: () -> String?)
    func warning(functionName: String, fileName: String, lineNumber: Int, @noescape closure: () -> String?)
    func error(functionName: String, fileName: String, lineNumber: Int, @noescape closure: () -> String?)
    func severe(functionName: String, fileName: String, lineNumber: Int, @noescape closure: () -> String?)
}

internal class SwiftyBeaconLogManager {
    
    var logger: Logger?
    
    func verbose(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, @noescape closure: () -> String?) {

        logger?.verbose(functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func debug(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, @noescape closure: () -> String?) {
        logger?.debug(functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func info(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, @noescape closure: () -> String?) {
        
        logger?.info(functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func warning(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, @noescape closure: () -> String?) {
        
        logger?.warning(functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func error(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, @noescape closure: () -> String?) {
        
        logger?.error(functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
    
    func severe(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, @noescape closure: () -> String?) {
        
        logger?.severe(functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
}