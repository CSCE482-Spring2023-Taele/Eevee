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
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}

    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
    { signInResult, error in
      guard let result = signInResult else {
        // Inspect error
        return
      }
      // If sign in succeeded, display the app's main content View.
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
                .opacity(0.95)
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