import SwiftUI

struct FooterSection: View {
    
    /**
     This is a struct that creates the swipe page view that the users see
     ## Important Notes ##
     1. This creates a list of eligible profiles based on cards created in the card struct
     
     - parameters:
        -a: UserAuthModel is the object vm that stores all the information from the logged in user
     
     - returns:
     the swipe page
     */
    
    @EnvironmentObject var vm: UserAuthModel
    
    /**
        This is a function that allows the user to sign out and go back to the login page
     */
    fileprivate func SignOutButton() -> Button<Text> {
        Button(action: {
            vm.signOut()
        }) {
            Text("Sign Out")
        }
    }
    /**
        This creates the list of cards that are shown to the user and formats the overall look of the swipe page
     */
    var body: some View {
        VStack {
            Button(action: {}) {
                Image("puppy-icon")
                    .resizable().aspectRatio(contentMode:
                            .fit).frame(height:45)
            }
            SignOutButton()
            ZStack{
                ForEach(Card.data.reversed()) { card in
                    CardView(card: card)
                }
            }
            .padding(8)
            .zIndex(1.0)
            Spacer()
        }
    }
}

struct FooterSection_Previews: PreviewProvider {
    /**
     This struct calls for footer section to show up the swipe page
     */
    static var previews: some View {
        FooterSection()
    }
}
