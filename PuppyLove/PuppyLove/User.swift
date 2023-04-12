//
//  User.swift
//  PuppyLove
//
//  Created by Reagan Green on 4/3/23.
//

import Foundation
import CoreLocation


class User: Codable, Identifiable, ObservableObject {
    let id = UUID()
    var OwnerID: Int
    var OwnerName: String
    var OwnerEmail: String
    var Age: Int?
    var MinAge: Int
    var MaxAge: Int
    var Sex: String
    var SexPreference: String
    var Location: String
    var MaxDistance: Int

    init(OwnerID: Int, OwnerName: String, OwnerEmail: String, Age: Int, MinAge: Int, MaxAge: Int, Sex: String, SexPreference: String, Location: String, MaxDistance: Int) {
        self.OwnerID = OwnerID
        self.OwnerName = OwnerName
        self.OwnerEmail = OwnerEmail
        self.Age = Age
        self.MinAge = MinAge
        self.MaxAge = MaxAge
        self.Sex = Sex
        self.SexPreference = SexPreference
        self.Location = Location
        self.MaxDistance = MaxDistance
    }
    
    func calculateAge(birthday: Date) {
        let today = Date.now
        let age = Calendar.current.dateComponents([.year], from: birthday, to: today)
        self.Age = age.year
    }
}

