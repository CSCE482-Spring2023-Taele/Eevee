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
    
    struct iOSCheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()
            }, label: {
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    configuration.label
                }
            })
        }
    }

    
    struct checklistItem: Identifiable, Hashable {
        var title: String
        var choice: Bool
        var id = UUID()
    }
    
    @State var genderPreferences = [
        checklistItem(title: "Male", choice: false),
        checklistItem(title: "Female", choice: false),
        checklistItem(title: "Non-binary", choice: false),
    ]
    
    @State var dogAgePreferences = [
        checklistItem(title: "Puppy (0-1 years)", choice: false),
        checklistItem(title: "Young (1-4 years)", choice: false),
        checklistItem(title: "Adult (4-8 years)", choice: false),
        checklistItem(title: "Senior (8+ years)", choice: false)
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
                ForEach($dogAgePreferences) { $item in
                    Toggle(item.title, isOn: $item.choice)
                        .toggleStyle(iOSCheckboxToggleStyle())
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
