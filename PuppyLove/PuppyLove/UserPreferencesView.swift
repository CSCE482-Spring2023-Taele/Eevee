//
//  UserPreferencesView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import SwiftUI

struct UserPreferencesView: View {
    @State var distance: Double = 0
    @State var minAge: Double = 18
    @State var maxAge: Double = 100
    
    struct checklistItem: Identifiable, Hashable {
        let title: String
        let id = UUID()
    }
    
    let genderPreferences = [
        checklistItem(title: "Male"),
        checklistItem(title: "Female"),
        checklistItem(title: "Non-binary"),
    ]
    
    let dogAgePreferences = [
        checklistItem(title: "Puppy (0-1 years)"),
        checklistItem(title: "Young (1-4 years)"),
        checklistItem(title: "Adult (4-8 years)"),
        checklistItem(title: "Senior (8+ years)")
    ]
    
    @State private var genderPrefChoices = Set<String>()
    @State private var dogAgePrefChoices = Set<String>()


    var body: some View {
        Form {
            Section(header: Text("Distance")) {
                Slider(value: $distance, in: 0...100, step: 1)
                Text("\(distance) miles")
            }.padding()
            
            Section(header: Text("Age Range")) {
                Slider(value: $distance, in: 0...100, step: 1)
            }.padding()
            
            Section(header: Text("Show Me...")) {
                VStack {
                    List(genderPreferences, selection: $genderPrefChoices){
                        Text($0.title)
                    }
                }
            }.padding()
        }
    }
}

struct UserPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferencesView()
    }
}
