//
//  LoginView.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/15/23.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

func handleSignInButton() {
    let mainViewController = UIViewController()
    GIDSignIn.sharedInstance.signIn(withPresenting: mainViewController)
    { signInResult, error in
      guard let result = signInResult else {
        // Inspect error
        return
      }
      // If sign in succeeded, display the app's main content View.
        ContentView()
    }
}

struct LoginView: View {
    var body: some View {
        VStack {
            Text("PuppyLove")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontDesign(.serif)
                .fontWidth(.expanded)
                .fontWeight(.heavy)
                .offset(x: 0, y: -100)
            
            GoogleSignInButton(action: handleSignInButton)
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(red: 0.784, green: 0.635, blue: 0.784))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
