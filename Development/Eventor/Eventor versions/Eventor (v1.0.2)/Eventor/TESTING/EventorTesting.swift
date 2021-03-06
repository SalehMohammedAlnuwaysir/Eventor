//
//  EvntorTesting.swift
//  Eventor
//
//  Created by YAZEED NASSER on 25/03/2019.
//  Copyright ยฉ 2019 Eventor. All rights reserved.
//

import Foundation

class EventorTesting{
    static let EvntorTestObj: EventorTesting = EventorTesting.init()
    
    private init(){
        
    }
    
    private func symbol(_ keySymbol:String)->  String{
        
        /// Verbose ๐ฃ - A verbose message, usually useful when working on a specific problem
        
        /// Debug ๐ - A debug message
        
        /// Info โน๏ธ - An info message
        
        /// Warning โ ๏ธ - A warning message, may indicate a possible error
        
        ///Testing ๐งช : no enough testing ,or need to be testsed
        
        /// Error โ๏ธ - An error occurred, but it's recoverable, just info about what happened
        
        /// Severe ๐ - A severe error occurred, we are likely about to crash now
        
        switch keySymbol {
        case "v" : return "๐ฃ"
        case "d" : return "๐"
        case "i" : return "โน๏ธ"
        case "w" : return "โ ๏ธ"
        case "t" : return "๐งช"
        case "e" : return "โ๏ธ"
        case "s" : return "๐"
        default:
            return ""
        }
    }

    /*
     
     [test keySymbols]
     v - Verbose ๐ฃ : specific problem
     d - Debug ๐ : debug message
     i - Info โน๏ธ : info message
     w - Warning โ ๏ธ : may indicate a possible error
     t - Testing ๐งช : no enough testing ,or need to be testsed
     e - Error โ๏ธ : error occurred, but it's recoverable
     s - Severe ๐ : error occurred, we are likely about to crash now

 */
    func WarningTestMsgFor(testKeySymbol:String
        ,funcName:String,inFileName:String,testingVersion:Int,testerName:String,testerMsg:String){
        
        
        print("โโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโ")
        print("โ[\(testKeySymbol.capitalized)] \(symbol(testKeySymbol)) : ")
        print("โ\(testerName) [testVer-\(testingVersion)] :- Func->[\(funcName)()] has NOT been tested yet!!! (IF you did [tested it! 100%] pls delete this print msg from Code >>> [\(funcName)() (in)-> \(inFileName) ])")
        print("โ ---> \(testerName)'s Message : \(testerMsg == "" ? "no message! sorry" : testerMsg) ")
        print("โโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโ")
      
    }
}

