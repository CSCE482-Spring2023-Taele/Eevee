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
    
    struct CheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()
            }, label: {
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    configuration.label
                }
                .onTapGesture {
                    configuration.isOn.toggle()
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
            
            Section(header: Text("Dog Preference Settings")) {
                ForEach($dogAgePreferences) { $item in
                    Toggle(isOn: $item.choice) {
                        Text("\(item.title)")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
            }.padding()
            
            Section(header: Text("User Preference Settings")) {
                ForEach($genderPreferences) { $item in
                    Toggle(isOn: $item.choice) {
                        Text("\(item.title)")
                    }
                    .toggleStyle(CheckboxToggleStyle())
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
