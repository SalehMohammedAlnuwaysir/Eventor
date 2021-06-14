//
//  EvntorTesting.swift
//  Eventor
//
//  Created by YAZEED NASSER on 25/03/2019.
//  Copyright © 2019 Eventor. All rights reserved.
//

import Foundation

class EventorTesting{
    static let EvntorTestObj: EventorTesting = EventorTesting.init()
    
    private init(){
        
    }
    
    private func symbol(_ keySymbol:String)->  String{
        
        /// Verbose 🗣 - A verbose message, usually useful when working on a specific problem
        
        /// Debug 🔍 - A debug message
        
        /// Info ℹ️ - An info message
        
        /// Warning ⚠️ - A warning message, may indicate a possible error
        
        ///Testing 🧪 : no enough testing ,or need to be testsed
        
        /// Error ❗️ - An error occurred, but it's recoverable, just info about what happened
        
        /// Severe 🛑 - A severe error occurred, we are likely about to crash now
        
        switch keySymbol {
        case "v" : return "🗣"
        case "d" : return "🔍"
        case "i" : return "ℹ️"
        case "w" : return "⚠️"
        case "t" : return "🧪"
        case "e" : return "❗️"
        case "s" : return "🛑"
        default:
            return ""
        }
    }

    /*
     
     [test keySymbols]
     v - Verbose 🗣 : specific problem
     d - Debug 🔍 : debug message
     i - Info ℹ️ : info message
     w - Warning ⚠️ : may indicate a possible error
     t - Testing 🧪 : no enough testing ,or need to be testsed
     e - Error ❗️ : error occurred, but it's recoverable
     s - Severe 🛑 : error occurred, we are likely about to crash now

 */
    func WarningTestMsgFor(testKeySymbol:String
        ,funcName:String,inFileName:String,testingVersion:Int,testerName:String,testerMsg:String){
        
        
        print("┌─────────────────────────────────────────────────────────────────")
        print("│[\(testKeySymbol.capitalized)] \(symbol(testKeySymbol)) : ")
        print("│\(testerName) [testVer-\(testingVersion)] :- Func->[\(funcName)()] has NOT been tested yet!!! (IF you did [tested it! 100%] pls delete this print msg from Code >>> [\(funcName)() (in)-> \(inFileName) ])")
        print("│ ---> \(testerName)'s Message : \(testerMsg == "" ? "no message! sorry" : testerMsg) ")
        print("└─────────────────────────────────────────────────────────────────")
      
    }
}

