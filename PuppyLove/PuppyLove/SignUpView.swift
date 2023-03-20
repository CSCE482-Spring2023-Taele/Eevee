//
//  SignUpView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("User Info")
                UserInfoView()
                
                Text("Preferences")
                UserPreferencesView()
                
                Text("Dog Information")
                AddDogView()
            }
        }.navigationBarTitle(Text("Sign Up"))
    }}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
