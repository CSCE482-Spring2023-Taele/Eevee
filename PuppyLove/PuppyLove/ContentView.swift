import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
    /**
     This is a struct that controls the main view of the app
     ## Important Notes ##
     1. This page controls what the user sees in the current view of the app depending on what stage of account creation they are in
     
     - parameters:
        -a: selection is a variable that saves the page state to see which page it is on, the swipe page, the login page, and the sign up page
        -b: UserAuthModel is the object vm that stores all the information from the logged in user
     
     - returns:
     whichever the page the user is supposed to be on based on the logged in account's status in our app
     */
    @State private var selection = 1
    @EnvironmentObject var vm: UserAuthModel
    
    var body: some View {
        if(vm.isLoggedIn == true && vm.hasAccount == true) {
            VStack {
                TabView(selection: $selection){
                    FooterSection()
                        .tabItem{
                            VStack {
                                Image(systemName: "heart")
                                Text("Swipe")
                            }
                        }
                        .tag(0)
                    ProfileView()
                        .font(.title)
                        .tabItem{
                            VStack{
                                Image(systemName:"person")
                                Text("Profile")
                            }
                        }
                        .tag(1)
                    CardsSection()
                        .tabItem{
                            VStack {
                                Image(systemName:"message")
                                Text("Bark")
                            }
                        }
                        .tag(2)

                }
            }
        }
        else if(vm.isLoggedIn == true) {
                SignUpView()
        }
        else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    /**
     This struct calls for content view to show up
     */
    static var previews: some View {
        ContentView()
        
    }
}

/*
// Code to launch izzys sign up page

 struct ContentView: View {
     var body: some View {
         NavigationView {
             SignUpView()
         }.navigationTitle("Sign Up")
     }
 }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 */
