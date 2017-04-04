//
//  QuestionProvider.swift
//  TheHaloQuiz
//
//  Created by TJ Barber on 3/27/17.
//  Copyright © 2017 TJ Barber. All rights reserved.
//

import Foundation
import GameKit

enum DataError : Error {
    case unableToShuffleData
    case unableToFindFile
    case unableToConvertStringToArray
}

struct Event {
    var description: String
    var year: Float
}

protocol EventDataProvider {
    var currentEventSet: [Event] { get set }
    var correctEventOrderByYear: [Float] { get set }
    var totalEventSet: [Event] { get set }
    
    func rearrangeEventsBySwapping(firstEvent firstIndex: Int, andSecondEvent secondIndex: Int)
    func prepareEventData(_ rawEventCollection: [[String: AnyObject]]) -> [Event]
    func prepareNewEventSet() throws -> [Event]
    func isOrderCorrect() -> Bool
    init(withEventFile fileName: String, ofType type: String) throws
}

class HaloEventProvider: EventDataProvider {
    var currentEventSet: [Event]
    var totalEventSet: [Event]
    var correctEventOrderByYear: [Float]
    
    required init(withEventFile fileName: String, ofType type: String) throws {
        self.currentEventSet = [Event]()
        self.totalEventSet = [Event]()
        self.correctEventOrderByYear = [Float]()
        
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: type) else {
            throw DataError.unableToFindFile
        }
        
        guard let rawData = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else {
            throw DataError.unableToConvertStringToArray
        }
        
        self.totalEventSet = prepareEventData(rawData)

        do {
            self.currentEventSet = try prepareNewEventSet()
        } catch (let error) {
            throw error
        }
        
        self.correctEventOrderByYear = self.currentEventSet.flatMap({ event in event.year }).sorted()
    }
    
    func rearrangeEventsBySwapping(firstEvent firstIndex: Int, andSecondEvent secondIndex: Int) {
        let event1 = currentEventSet[firstIndex]
        let event2 = currentEventSet[secondIndex]

        currentEventSet[secondIndex] = event1
        currentEventSet[firstIndex] = event2
    }
    
    func isOrderCorrect() -> Bool {
        if currentEventSet.flatMap({ event in event.year }) == correctEventOrderByYear {
            return true
        }
        return false
    }
    
    func prepareEventData(_ rawEventCollection: [[String: AnyObject]]) -> [Event] {
        var eventCollection = [Event]()
        for rawEvent in rawEventCollection {
            if let description = rawEvent["description"] as? String, let year = rawEvent["year"] as? Float {
                let event = Event(description: description, year: year)
                eventCollection.append(event)
            } else {
                // Either the description or the year ended up being nil, skipping this one
                continue
            }
        }
        
        return eventCollection
    }
    
    func prepareNewEventSet() throws -> [Event] {
        var arrayOfEventIndices = [Int]()
        var arrayOfEvents = [Event]()
        while arrayOfEventIndices.count < 4 {
            let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: totalEventSet.count)
            if arrayOfEventIndices.index(of: randomIndex) != nil {
                continue
            }
            
            arrayOfEventIndices.append(randomIndex)
            arrayOfEvents.append(totalEventSet[randomIndex])
        }
        
        guard let randomizedEvents = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: arrayOfEvents) as? [Event] else {
            throw DataError.unableToShuffleData
        }
        
        return randomizedEvents
    }
    
}
