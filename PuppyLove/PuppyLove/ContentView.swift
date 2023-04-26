import SwiftUI
import GoogleSignIn


struct ContentView: View {
    @State private var selection = 1
    @EnvironmentObject var vm: UserAuthModel
    
    var body: some View {
        if(vm.isLoggedIn == true && vm.hasAccount == true) {
            VStack {
                TabView(selection: $selection){
                    FooterSection()
                        .tabItem{
                            VStack {
                                Image(systemName: "person")
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
                                Image(systemName:"person")
                                Text("Bark")
                            }
                        }
                        .tag(2)
                    
                }
            }
        }
        else if(vm.isLoggedIn == true) {
                NavigationView {
                    SignUpView()
                }//.navigationTitle("Sign Up")
        }
        else {
            LoginView()
            // SignUpView()
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
