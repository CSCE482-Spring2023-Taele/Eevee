import SwiftUI

struct FooterSection: View {
    var body: some View {
        VStack {
            //            Spacer()
            //            Button(action: {}) {
            //                Image("puppy-icon")
            //                    .resizable().aspectRatio(contentMode: .fit).frame(height:45)
            //            }
            //
            //            Spacer()
            //            Button(action: {}) {
            //                Image("chats")
            //            }
            //        }.padding([.horizontal, .bottom])
            Button(action: {}) {
                Image("puppy-icon")
                    .resizable().aspectRatio(contentMode:
                            .fit).frame(height:45)
            }
            ZStack{
                ForEach(Card.data.reversed()) { card in
                    CardView(card: card)
                }
            }
            .padding(8)
            .zIndex(1.0)
            Spacer()
            HStack {
                Button(action: {}) {
                Image("dismiss")
            }
                Button(action: {}) {
                    Image("like")
                }
            }
            Spacer()
        }
    }
}

struct FooterSection_Previews: PreviewProvider {
    static var previews: some View {
        FooterSection()
    }
}
