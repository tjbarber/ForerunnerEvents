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
}

// enum EventCategory {
//   .gameHistory
//   .
// }

protocol Event {
    var description: String { get }
    //var category: EventCategory // come back to this
    var year: Int { get }
   // var link: URL { get }
}

protocol EventDataProvider {
    var currentEventSet: [Event] { get set }
    var correctEventOrderByYear: [Int] { get set }
    var totalEventSet: [Event] { get set }
    
    func rearrangeEventsBySwapping(firstEvent firstIndex: Int, andSecondEvent secondIndex: Int)
    func prepareNewQuizSet() -> [Event]
    func isOrderCorrect() -> Bool
    init() throws
}

struct HaloEvent: Event {
    var description: String
    var year: Int
    //var link: URL
}

class HaloEventProvider: EventDataProvider {
    var currentEventSet: [Event]
    var totalEventSet: [Event]
    var correctEventOrderByYear: [Int]
    
    required init() throws {
        let event1 = HaloEvent(description: "The ORION Project is re-initiated. The first successful batch of augmentees are code-named \"SPARTANs.\"", year: 2491)
        let event2 = HaloEvent(description: "A young boy named John is born.", year: 2511)
        let event3 = HaloEvent(description: "Following the war against the Covenant, the SPARTAN-IV Program is greenlit.", year: 2553)
        let event4 = HaloEvent(description: "The UNSC Infinity is officially commissioned.", year: 2557)
        
        self.totalEventSet = [event1, event2, event3, event4]
        self.correctEventOrderByYear = self.totalEventSet.flatMap { event in event.year }
        
        guard let shuffledEvents = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.totalEventSet) as? [Event] else {
            throw DataError.unableToShuffleData
        }
        
        self.currentEventSet = shuffledEvents
    }
    
    func rearrangeEventsBySwapping(firstEvent firstIndex: Int, andSecondEvent secondIndex: Int) {
        let event1 = currentEventSet[firstIndex]
        let event2 = currentEventSet[secondIndex]

        currentEventSet[secondIndex] = event1
        currentEventSet[firstIndex] = event2
    }
    
    func isOrderCorrect() -> Bool {
        if currentEventSet.flatMap({ event in event.year}) == correctEventOrderByYear {
            return true
        }
        return false
    }
    
    func prepareNewQuizSet() -> [Event] {
        return self.currentEventSet
    }
    
}
