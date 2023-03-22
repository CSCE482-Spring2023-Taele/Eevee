import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @State private var selection = 1
    var body: some View {
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
                }
            /*         LoginView()
             .onOpenURL { url in
             GIDSignIn.sharedInstance.handle(url) }
             }
             */
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}



