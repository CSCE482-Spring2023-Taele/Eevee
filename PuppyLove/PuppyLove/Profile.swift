
//
//  Profile.swift
//  PuppyLove
//
//  Created by Irving Salinas on 3/16/23.
//

import SwiftUI
import Amplify

struct Profile: View {
    let profileLinkNames: [String] = ["Dog/s", "Name", "Birthday","Email","Gender",
    "Height","Location","Age Range", "Political Affiliation", "Religion", "Do you Drink/Smoke"
     ]
    
    @EnvironmentObject var vm: UserAuthModel
    @State var userPhoto: Data? = nil
    @State var profilePhoto: UIImage?
    func downloadImage() async throws {
        print("downloading image")
        let imageKey: String = "\(vm.emailAddress)"
        let downloadTask = Amplify.Storage.downloadData(key: imageKey)
            Task {
                for await progress in await downloadTask.progress {
                    print("Progress: \(progress)")
                }
            }
        userPhoto = try await downloadTask.value
        print("Completed")
    }

    // Keeping this here, just uncomment for actual profile page functionality
    // Showing the implementation of the function
    var body: some View {
        VStack {
            if let userPhoto,
               let image = UIImage(data: userPhoto) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                }
        }
        .onAppear {
            Task {
                // Showing the implementation of the function
                try await downloadImage()
            }
        }
//        NavigationView {
//            VStack(spacing:0) {
//                ForEach(profileLinkNames, id: \.self) { profileLinkName in ProfileLink(profileLinkName: profileLinkName)
//                }
//                Spacer()
//            }
//            .navigationBarTitle("Martha Green")
//            .navigationBarItems(leading:Text("Owner")
//                .font(.body)
//                .foregroundColor(Color(.systemGray)),
//                                trailing: Image("Kate")
//                                          .resizable()
//                                          .frame(width: 40, height: 40)
//                                          .clipShape(Circle()))
//        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ProfileLink: View {
    let profileLinkName: String
    var body: some View {
        NavigationLink(destination: Text("")){
            VStack(spacing: 0) {
                HStack {
                    Text(profileLinkName)
                        .font(.body)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(.systemGray3))
                        .font(.system(size: 20))
                }
                .contentShape(Rectangle())
                .padding(EdgeInsets(top: 17, leading: 21, bottom: 17, trailing: 21))
                Divider()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
