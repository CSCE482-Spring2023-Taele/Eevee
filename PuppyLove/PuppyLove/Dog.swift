//
//  Dog.swift
//  PuppyLove
//
//  Created by Reagan Green on 4/6/23.
//

import Foundation


class Dog: Codable, Identifiable, ObservableObject {
    let id = UUID()
    var DogID: Int
    var OwnerID: Int
    var DogName: String
    var Breed: String
    var Weight: Int
    var Age: String
    var Sex: String
    var ActivityLevel: Int
    var VaccinationStatus: Bool
    var FixedStatus: Bool
    var BreedPreference: String
    var AdditionalInfo: String
    
    init(DogID: Int, OwnerID: Int, DogName: String, Breed: String, Weight: Int, Age: String, Sex: String, ActivityLevel: Int, VaccinationStatus: Bool, FixedStatus: Bool, BreedPreference: String, AdditionalInfo: String) {
        self.DogID = DogID
        self.OwnerID = OwnerID
        self.DogName = DogName
        self.Breed = Breed
        self.Weight = Weight
        self.Age = Age
        self.Sex = Sex
        self.ActivityLevel = ActivityLevel
        self.VaccinationStatus = VaccinationStatus
        self.FixedStatus = FixedStatus
        self.BreedPreference = BreedPreference
        self.AdditionalInfo = AdditionalInfo
    }
}
