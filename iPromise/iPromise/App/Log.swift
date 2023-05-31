//
//  Log.swift
//  iPromise
//
//  Created by Apple on 28/03/23.
//

import Foundation

enum Log{
    enum LogLevel{
        case info
        case warning
        case error
        
        fileprivate var prefix : String{
            switch self{
                case .info : return "INFO"
                case .warning : return "WARNING ⚠️"
                case .error  : return "ERROR ❌"
            }
        }
    }
    struct Context {
        var file : String
        //var function : String
        var line : Int
        var description : String{
//            return "\((file as NSString).lastPathComponent) : \(line) \(function)"
            return "\((file as NSString).lastPathComponent) : \(line) "
        }
    }
    
    
    static func info(_ str : String, file : String = #file, function : String = #function, line : Int = #line ){
        let context = Context(file: file,line: line) //Context(file: file, function: function, line: line)
        Log.handleLog(level: .info, str: str.description, context: context)
    }
    static func warning(_ str : StaticString, file : String = #file, function : String = #function, line : Int = #line ){
        let context =  Context(file: file,line: line) //Context(file: file, function: function, line: line)
        Log.handleLog(level: .warning, str: str.description, context: context)
    }
    static func error(_ str : String, file : String = #file, function : String = #function, line : Int = #line ){
        let context =  Context(file: file,line: line) //Context(file: file, function: function, line: line)
        Log.handleLog(level: .error, str: str.description, context: context)
    }
    
    
    fileprivate static func handleLog(level : LogLevel, str : String, context : Context){
        let logComponent = ["[\(level.prefix)] "]
        var fullString = logComponent.joined(separator: " ")
        fullString += "\(context.description) - \(str)"
        
        #if DEBUG
        print(fullString)
        #endif
        
    }
    
}
