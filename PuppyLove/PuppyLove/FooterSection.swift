import SwiftUI

struct FooterSection: View {
    
    @EnvironmentObject var vm: UserAuthModel
    fileprivate func SignOutButton() -> Button<Text> {
        Button(action: {
            vm.signOut()
        }) {
            Text("Sign Out")
        }
    }
    
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
    static var previews: some View {
        FooterSection()
    }
}
