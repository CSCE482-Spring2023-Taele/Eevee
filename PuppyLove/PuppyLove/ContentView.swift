import SwiftUI
import GoogleSignIn

struct User {
    var name: String
    var age: Int
    var bio: String
    var gender: String
    var profilePicture: UIImage
}

struct Dog {
    var name: String
    var age: String
    var activityLevel: Double
    var bio: String
    var profilePicture: Data
    var vaccinated: Bool
    var fixed: Bool
}

struct ContentView: View {
    @State private var selection = 1
    @EnvironmentObject var vm: UserAuthModel
    var body: some View {
        if(vm.isLoggedIn == true) {
            VStack {
                TabView(selection: $selection){
                    FooterSection()
                        .tabItem{
                            VStack {
                                Image(systemName: "card")
                                Text("Swipe")
                            }
                        }
                        .tag(0)
                    Profile()
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
                                Image(systemName:"chat")
                                Text("Bark")
                            }
                        }
                        .tag(2)
                    
                }
            }
        }
        else {
            LoginView()
        }
//        NavigationView {
//            SignUpView()
//        }.navigationTitle("Sign Up")
    }
}

struct ContentView_Previews: PreviewProvider {
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
