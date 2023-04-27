//
//  ProfileView.swift
//  PuppyLove
//
//  Created by Truitt Millican on 4/9/23.
//

import SwiftUI
import Amplify

struct ProfileView: View {
    @State var isPresented = false
    
    // Setup for including photo
    @EnvironmentObject var vm: UserAuthModel
    @State var userPhoto: Data? = nil
    @State var profilePhoto: UIImage?
    func downloadImage() async throws {
        print("downloading image")
        let imageKey: String = "aaronsanchez01@tamu.edu"
        let downloadTask = Amplify.Storage.downloadData(key: imageKey)
            Task {
                for await progress in await downloadTask.progress {
                    print("Progress: \(progress)")
                }
            }
        userPhoto = try await downloadTask.value
        print("Completed")
    }

    var body: some View {
        
        // Exmaple use of loading photo onto page
//        VStack {
//            if let userPhoto,
//               let image = UIImage(data: userPhoto) {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 100, height: 100)
//                }
//        }
//        .onAppear {
//            Task {
//                // Showing the implementation of the function
//                try await downloadImage()
//            }
//        }
        
        VStack {
            VStack {
                Header()
                ProfileText()
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
    @AppStorage("name") var name = DefaultSettings.name
    @AppStorage("age") var age = DefaultSettings.age
    @AppStorage("gender") var gender = DefaultSettings.gender
    @AppStorage("description") var description = DefaultSettings.description
    @AppStorage("minAge") var minAge = DefaultSettings.minAge
    @AppStorage("maxAge") var maxAge = DefaultSettings.maxAge
    @AppStorage("maxDistance") var maxDistance = DefaultSettings.maxDistance
    @AppStorage("dogName") var dogName = DefaultSettings.dogName
    @AppStorage("dogBreed") var dogBreed = DefaultSettings.dogBreed
    
    
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text(name)
                    .bold()
                    .font(.title)
                Text(age)
                    .font(.body)
                    .foregroundColor(.secondary)
                Text(gender)
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
