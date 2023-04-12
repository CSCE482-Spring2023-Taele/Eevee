//
//  SignUpView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var user = User(OwnerID: 0, OwnerName: "", OwnerEmail: "", Age: 0, MinAge: 18, MaxAge: 100, Sex: "Male", SexPreference: "Everyone", Location: "", MaxDistance: 100)
    
    @StateObject var dog = Dog(DogID: 0, OwnerID: 0, DogName: "", Breed: "", Weight: 0, Age: "Puppy (0-1 years)", Sex: "Male", ActivityLevel: 0, VaccinationStatus: false, FixedStatus: false, BreedPreference: "none", AdditionalInfo: "")
    
    var body: some View {
        UserInfoView(user: user, dog: dog)
    }}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
