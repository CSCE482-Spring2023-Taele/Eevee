//
//  UserPreferencesView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import SwiftUI

struct UserPreferencesView: View {
    @StateObject var user: User
    @StateObject var dog: Dog
    
    var sexPreferences = ["Male", "Female", "Non-binary", "Everyone"]
    @State var selectedPreference = "Male"
    
    @State var distance: Double = 0
    @State var minAge: Int = 18
    @State var maxAge: Int = 100
    
    // API call POST owner
    func sendRequest() async {
        print("sendRequest()")
        guard let encoded = try? JSONEncoder().encode(user) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://puppyloveapi.azurewebsites.net/Owner")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            // this is where i try to get the ID but it doesn't work
            let decodedUser = try JSONDecoder().decode(User.self, from: data)
            dog.OwnerID = decodedUser.OwnerID
            dump(decodedUser)

        } catch {
            print("POST  failed.")
        }
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Distance")) {
                    Slider(value: $distance, in: 0...100, step: 1)
                    Text("\(Int(distance)) miles")
                }.padding()
                
                Section(header: Text("Owner Gender Preference")) {
                    HStack {
                        Picker("Show me...", selection: $selectedPreference) {
                            ForEach(sexPreferences, id: \.self, content: { sex in
                                Text(sex)
                            })
                        }
                    }
                }.padding()
                
                // This is ugly gotta look for new way to do this
                Section(header: Text("Minimum Owner Age")) {
                    HStack {
                        Picker("Select Age", selection: $minAge){
                            ForEach(18 ..< 100) {
                                Text("\($0)")
                            }
                        }
                    }
                }.padding()
                
                Section(header: Text("Maximum Owner Age")) {
                    HStack {
                        Picker("Select Age", selection: $maxAge){
                            ForEach(18 ..< 100) {
                                Text("\($0)")
                            }
                        }
                    }
                }.padding()
            }
            NavigationLink(destination: AddDogView(dog: dog).onAppear {
                user.SexPreference = selectedPreference
                
                // change email or else post wont work, need to grab email from oAuth process
                user.OwnerEmail = "reagan@gmail.com"
                user.MaxDistance = Int(distance)
                user.MaxAge = Int(maxAge)
                user.MinAge = Int(minAge)
                user.Location = "College Station"
                Task {
                    await sendRequest()
                }
            }, label: {
                    Text("Next")
            })
        }
        .navigationBarTitle(Text("User Preferences"))
    }
}

struct UserPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferencesView(
            user: User(OwnerID: 0, OwnerName: "", OwnerEmail: "", Age: 0, MinAge: 0, MaxAge: 0, Sex: "", SexPreference: "", Location: "", MaxDistance: 0),
            dog: Dog(DogID: 0, OwnerID: 0, DogName: "", Breed: "", Weight: 0, Age: "", Sex: "", ActivityLevel: 0, VaccinationStatus: false, FixedStatus: false, BreedPreference: "none", AdditionalInfo: "")
        )
    }
}
