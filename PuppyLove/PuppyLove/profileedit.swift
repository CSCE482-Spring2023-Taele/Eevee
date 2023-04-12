//
//  profileedit.swift
//  PuppyLove
//
//  Created by Truitt Millican on 3/22/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                HeaderBackgroundSliders()
                ProfileSettings()
            }
            .navigationBarTitle(Text("Settings"))
            .navigationBarItems(
                trailing:
                    Button (
                        action: {
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Text("Done")
                        }
                    )
            )
        }
    }
}
struct ProfileSettings: View {
    @AppStorage("name") var name = DefaultSettings.name
    @AppStorage("age") var age = DefaultSettings.age
    @AppStorage("gender") var gender = DefaultSettings.gender
    @AppStorage("description") var description = DefaultSettings.description
    @AppStorage("minAge") var minAge = DefaultSettings.minAge
    @AppStorage("maxAge") var maxAge = DefaultSettings.maxAge
    @AppStorage("sexPreference") var sexPreference = DefaultSettings.sexPreference
    @AppStorage("maxDistance") var maxDistance = DefaultSettings.maxDistance
    @AppStorage("dogName") var dogName = DefaultSettings.dogName
    @AppStorage("dogBreed") var dogBreed = DefaultSettings.dogBreed
    
    var body: some View {
        Section(header: Text("Profile")) {
            Button (
                action: {
                    // Action
                },
                label: {
                    Text("Pick Profile Image")
                }
            )
            TextField("Name", text: $name)
            TextField("Age", text: $age)
            TextField("Gender", text: $gender)
            TextEditor(text: $description)
            TextField("Minimum Age",text: $minAge )
            TextField("Maximum Age",text: $maxAge )
            TextField("Sex Preference",text: $sexPreference )
            TextField("Dog Name" , text: $dogName )
            TextField("Dog Breed" , text: $dogBreed )
            
            
        }
    }
}

struct HeaderBackgroundSliders: View {
    @AppStorage("rValue") var rValue = DefaultSettings.rValue
    @AppStorage("gValue") var gValue = DefaultSettings.gValue
    @AppStorage("bValue") var bValue = DefaultSettings.bValue
    
    var body: some View {
        Section(header: Text("Header Background Color")) {
            HStack {
                VStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 100)
                        .foregroundColor(Color(red: rValue, green: gValue, blue: bValue, opacity: 1.0))
                }
                //                VStack {
                //                    Text("R: \(Int(rValue * 255.0))")
                //                    Text("G: \(Int(gValue * 255.0))")
                //                    Text("B: \(Int(bValue * 255.0))")
                //                }
                VStack {
                    colorSlider(value: $rValue, textColor: .red)
                    colorSlider(value: $gValue, textColor: .green)
                    colorSlider(value: $bValue, textColor: .blue)
                }
            }
        }
    }
}



struct profileedit_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
