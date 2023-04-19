//
//  UserPreferencesView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import SwiftUI

struct DecodedUser: Codable {
    let ownerID: Int?
    let ownerName: String?
    let ownerEmail: String?
    let age: Int?
    let minAge: Int?
    let maxAge: Int?
    let sex: String?
    let sexPreference: String?
    let location: String?
    let maxDistance: Int?
}

struct UserPreferencesView: View {
    @EnvironmentObject var vm: UserAuthModel
    @StateObject var user: User
    @StateObject var dog: Dog
    
    var sexPreferences = ["Male", "Female", "Non-binary", "Everyone"]
    @State var selectedPreference = "Male"
    
    @State var distance: Double = 100
    @State var minAge: Int = 18
    @State var maxAge: Int = 100
    
    // API call POST owner
    func sendRequest() async {
        print("sendRequest()")
        guard let encoded = try? JSONEncoder().encode(user) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/Owner")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            do {
                let decodedUser = try JSONDecoder().decode(DecodedUser.self, from: data)
                dog.OwnerID = decodedUser.ownerID ?? 0

            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print("Decoding failed.")
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
                
                Section(header: Text("Owner Age Preference")) {
                    VStack {
                        Stepper("Minimum Age: \(minAge)", value: $minAge, in: 18...100)
                        Stepper("Maximum Age: \(maxAge)", value: $maxAge, in: minAge...100)
                    }
                }.padding()
            }
            NavigationLink(destination: AddDogView(dog: dog).onAppear {
                user.SexPreference = selectedPreference
                
                // change email or else post wont work, need to grab email from oAuth process
                user.OwnerEmail = vm.emailAddress
                user.MaxDistance = Int(distance)
                user.MaxAge = Int(maxAge)
                user.MinAge = Int(minAge)
                dump(user)
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
