//
//  AddDogView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import SwiftUI

struct AddDogView: View {
    @State private var dogName = ""
    @State private var ageRange = ""
    @State private var activityLevel: Double = 0
    @State private var ageRangeTag: Int = 0
    
    var sexOptions = ["Male", "Female"]
    @State var sexOptionTag: Int = 0
    
    var ageOptions = ["Puppy (0-1 years)", "Young (1-4 years)", "Adult (4-8 years)", "Senior (8+ years)"]
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $dogName)
            }.padding()
            
            Section(header: Text("Activity Level")) {
                Slider(
                    value: $activityLevel,
                    in: 0...10,
                    step: 1
                )
            }.padding()
            
            Section(header: Text("Sex")) {
                HStack {
                    Picker("Select Sex", selection: $sexOptionTag) {
                        ForEach(0 ..< sexOptions.count) {
                            Text(self.sexOptions[$0])
                        }
                    }
                }
            }.padding()
            
            Section(header: Text("Age")) {
                HStack {
                    Picker("Age range", selection: $ageRange){
                        ForEach(0 ..< ageOptions.count) {
                            Text(self.ageOptions[$0])
                        }
                    }
                }
                
            }.padding()
        }
        
        Button("Save") {
            let newDog = Dog(name: dogName, age: ageRange, activityLevel: activityLevel)
            print(newDog)
        }.buttonStyle(.borderedProminent)
    }
}

struct AddDogView_Previews: PreviewProvider {
    static var previews: some View {
        AddDogView()
    }
}
