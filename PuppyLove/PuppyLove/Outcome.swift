//
//  Outcome.swift
//  PuppyLove
//
//  Created by Jennifer Choudhury on 4/19/23.
//

import Foundation

class Outcome: Codable, Identifiable, ObservableObject {
    let id = UUID()
    var outcomeID: Int
    var currDogID: Int
    var reviewedDogID: Int
    var timestamp: String
    var outcome: Int

    
    init(outcomeID: Int, currDogID: Int, reviewedDogID: Int, timestamp: String, outcome: Int) {
        self.outcomeID = outcomeID
        self.currDogID = currDogID
        self.reviewedDogID = reviewedDogID
        self.timestamp = timestamp
        self.outcome = outcome
    }
}
