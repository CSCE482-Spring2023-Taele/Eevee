
//
//  Profile.swift
//  PuppyLove
//
//  Created by Irving Salinas on 3/16/23.
//

import SwiftUI

struct Profile: View {
    let profileLinkNames: [String] = ["Dog/s", "Name", "Birthday","Email","Gender",
    "Height","Location","Age Range", "Political Affiliation", "Religion", "Do you Drink/Smoke"
     ]

    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                ForEach(profileLinkNames, id: \.self) { profileLinkName in ProfileLink(profileLinkName: profileLinkName)
                }
                Spacer()
            }
            .navigationBarTitle("Martha Green")
            .navigationBarItems(leading:Text("Owner")
                .font(.body)
                .foregroundColor(Color(.systemGray)),
                                trailing: Image("Kate")
                                          .resizable()
                                          .frame(width: 40, height: 40)
                                          .clipShape(Circle()))
        }
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
