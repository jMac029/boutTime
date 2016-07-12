//
//  HistoricalEventsModel.swift
//  boutTime
//
//  Created by James McMillan on 7/10/16.
//  Copyright © 2016 jamesdmcmillan. All rights reserved.
//

import Foundation

// MARK: Error Types

enum HistoricalEventsError: ErrorType {
    
    case InvalidResource
    case ConversionError
    case InvalidKey
}

// MARK: Classes

// Model the data converted from the plist data file

class HistoricalEvents {
    
    let event: String
    let year: Int
    let url: String
    
    init(event: String, year: Int, url: String) {
        
        self.event = event
        self.year = year
        self.url = url
    }
}

// MARK: Structs

struct USHistorialEventsQuiz {
    
    var historicalEvents: [HistoricalEvents]
    
    init(historicalEvents: [HistoricalEvents]) {
        
        self.historicalEvents = historicalEvents
    }
}


// MARK: Helper Classes

// Plist Conversion class, mostly copied from the VendingMachine App Course where it was demonstrated

class PlistConverter {
    // type method
    class func arrayFromFile(resource: String, ofType type: String) throws -> [[String : String]] {
        
        guard let path =
            NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
                throw HistoricalEventsError.InvalidResource
        }
        
        guard let array = NSArray(contentsOfFile: path),
            let castArray = array as? [[String: String]] else {
                throw HistoricalEventsError.ConversionError
        }
        
        return castArray
    }
    
}

// Unarchiver Class also mostly copied from the VendingMachine App Course where it was demonstrated

class HistoricalEventsUnarchiver {
    class func historicalEventsFromArray(array: [[String : String]]) -> [HistoricalEvents] {
        
        var historicalEventArray: [HistoricalEvents] = []
        
        for historicalEvent in array {
            if let event = historicalEvent["event"],
                let year = historicalEvent["year"],
                let yearAsInt = Int(year),
                let url = historicalEvent["url"] {
                let newHistoricalEvent = HistoricalEvents(event: event, year: yearAsInt, url: url)
                historicalEventArray.append(newHistoricalEvent)
            }
            
        }
        
        return historicalEventArray
        
    }
}