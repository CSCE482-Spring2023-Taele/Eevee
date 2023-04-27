//
//  ProfileView.swift
//  PuppyLove
//
//  Created by Truitt Millican on 4/9/23.
//

import SwiftUI
import Amplify

struct DecodeUser: Codable {
    
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



struct ProfileView: View {
    @State var isPresented = false

    var body: some View {
        VStack {
            VStack {
                Header()
                ProfileText(
                    user: User(OwnerID: 0, OwnerName: "", OwnerEmail: "", Age: 0, MinAge: 0, MaxAge: 0, Sex: "", SexPreference: "", Location: "", MaxDistance: 0),
                        dog: Dog(DogID: 0, OwnerID: 0, DogName: "", Breed: "", Weight: 0, Age: "", Sex: "", ActivityLevel: 0, VaccinationStatus: false, FixedStatus: false, BreedPreference: "none", AdditionalInfo: ""))
            }
            Spacer()
            Button (
                action: { self.isPresented = true },
                label: {
                    Label("Edit", systemImage: "pencil")
            })
            .sheet(isPresented: $isPresented, content: {
                SettingsView()
            })
        }
    }
}

struct ProfileText: View {
    @EnvironmentObject var vm: UserAuthModel
    @StateObject var user: User
    @StateObject var dog: Dog
    
    
    var SexPreference = ["Male","Female", "Non-binary", "Everyone"]
    @State var selectedPreference = "Male"
        

    @State var age: Int = 30
    @State var Sex: String = "Male"
    @State var Location: String = "Houston"
    @State var distance: Double = 100
    @State var minAge: Int = 18
    @State var maxAge: Int = 100


    @AppStorage("description") var description = DefaultSettings.description
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text(vm.givenName)
                    .bold()
                    .font(.title)
                Text(String(vm.ownerAge ?? 0))
                    .font(.body)
                    .foregroundColor(.secondary)
                Text(vm.ownerSex)
                    .font(.body)
                    .foregroundColor(.secondary)
                Text(vm.dogName)
                    .font(.body)
                    .foregroundColor(.secondary)
            }.padding()
            Text(description)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
           
        }
    }
}
/*
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif
*/
