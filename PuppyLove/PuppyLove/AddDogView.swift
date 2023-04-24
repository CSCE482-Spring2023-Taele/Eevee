//
//  AddDogView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct AddDogView: View {
    @StateObject var dog: Dog
    
    @State private var dogBreed = ""
    @State private var dogAge = "Puppy (0-1 years)"
    @State private var dogWeight: Int = 0
    @State private var dogSex = "Male"
    @State private var activityLevel: Double = 0
    @State private var vaccinated = false
    @State private var fixed = false
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var dogPhoto: Data? = nil
    
    @State var breeds = [Breed]()
    @State var selectedBreed = Breed(id: 0, name: "")
    
    var sexOptions = ["Male", "Female"]
    @State var selectedSex = "Male"
    
    var ageOptions = ["Puppy (0-1 years)", "Young (1-4 years)", "Adult (4-8 years)", "Senior (8+ years)"]
    @State var selectedAgeRange = "Puppy (0-1 years)"
    
    // API call POST the dog
    func sendRequest() async {
        print("sendRequest()")
        guard let encoded = try? JSONEncoder().encode(dog) else {
            print("Failed to encode dog")
            return
        }
        
        let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/Dog")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // handle the result
        } catch {
            print("POST  failed.")
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $dog.DogName)
                }.padding()
                
                Section(header: Text("Profile Picture")) {
                    HStack {
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                        .onChange(of: selectedPhoto) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    dogPhoto = data
                                }
                            }
                        }
                        Spacer()
                        if let dogPhoto,
                            let dogImage = UIImage(data: dogPhoto) {
                            Image(uiImage: dogImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                        }
                    }
                }.padding()
                
                Section(header: Text("Activity Level")) {
                    Slider(
                        value: $activityLevel,
                        in: 0...10,
                        step: 1
                    ) {
                    }
                    minimumValueLabel: {
                        Text("0").font(.title2).fontWeight(.thin)
                    } maximumValueLabel: {
                        Text("10").font(.title2).fontWeight(.thin)
                    }
                }.padding()
                
                Section(header: Text("Breed")) {
                    Picker("Select Breed", selection: $selectedBreed) {
                        ForEach(breeds, id: \.self, content: { breed in
                            Text(breed.name)
                        })
                    }
                    .onAppear() {
                        DogAPI().loadData { (breeds) in
                            self.breeds = breeds
                        }
                    }
                }.padding()
                
                Section(header: Text("Sex")) {
                    HStack {
                        Picker("Select sex", selection: $selectedSex) {
                            ForEach(sexOptions, id: \.self, content: { sex in
                                Text(sex)
                            })
                        }
                    }
                }.padding()
                
                Section(header: Text("Age")) {
                    HStack {
                        Picker("Age range", selection: $selectedAgeRange){
                            ForEach(ageOptions, id: \.self, content: { age in
                                Text(age)
                            })
                        }
                    }
                }.padding()
                
                Section(header: Text("Size")) {
                    HStack {
                        Picker("Select Weight (lbs)", selection: $dogWeight){
                            ForEach(1 ..< 150) {
                                Text("\($0)")
                            }
                        }
                    }
                }.padding()
                
                Section(header: Text("Bio")) {
                    TextField("Tell us about your pup...", text: $dog.AdditionalInfo,  axis: .vertical)
                        .lineLimit(5...10)
                }.padding()
                
                Section(header: Text("Vaccination Status")) {
                    Toggle("Up to date on annual vaccinations?", isOn: $vaccinated)
                }.padding()
                
                Section(header: Text("Fixed Status")) {
                    Toggle("Is your dog neutered/spayed?", isOn: $fixed)
                }.padding()
            }
            NavigationLink(destination: LoginView().onAppear {
                dog.Sex = selectedSex
                dog.Age = selectedAgeRange
                dog.Breed = selectedBreed.name
                dog.VaccinationStatus = vaccinated
                dog.FixedStatus = fixed
                dog.Weight = dogWeight
                dump(dog)
                Task {
                    await sendRequest()
                }
            }, label: { Text("Save")})
        }
        .navigationBarTitle(Text("Dog Information")).navigationBarBackButtonHidden()
    }
}

struct AddDogView_Previews: PreviewProvider {
    static var previews: some View {
        AddDogView(dog: Dog(DogID: 0, OwnerID: 0, DogName: "", Breed: "", Weight: 0, Age: "", Sex: "", ActivityLevel: 0, VaccinationStatus: false, FixedStatus: false, BreedPreference: "none", AdditionalInfo: ""))
    }
}
