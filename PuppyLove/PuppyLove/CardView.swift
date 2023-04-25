import SwiftUI

struct CardView: View {
    @State var card: Card
    @EnvironmentObject var vm: UserAuthModel
    @State var swipeOutcome = 0
    var outcome: Outcome? = Outcome(outcomeID: 0, currDogID: 0, reviewedDogID: 0, timestamp: "", outcome: 0)
    // MARK: - Drawing Constant
    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])

    func sendRequest() async {
        print("sendRequest() for swipe outcome")
        guard let outcome = outcome else {
                print("Outcome is nil")
                return
            }
        guard let encoded = try? JSONEncoder().encode(outcome) else {
            print("Failed to encode outcome")
            return
        }
        outcome.reviewedDogID = card.dogID
        if(swipeOutcome == 1) {
            outcome.outcome = 1
        }
        else {
            outcome.outcome = 0
        }
        let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/Swipe")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(outcome.currDogID)
            print(outcome.reviewedDogID)
            print(outcome.timestamp)
            print(outcome.outcome)
            // handle the result
        } catch {
            print("POST  failed.")
        }
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(card.imageName)
                .resizable()
                .clipped()
            LinearGradient(gradient: cardGradient, startPoint: .top, endPoint: .bottom)
            VStack {
                Spacer()
                VStack(alignment: .leading){
                    HStack {
                        Text(card.name).font(.largeTitle).fontWeight(.bold)
                        Text(String(card.age)).font(.title)
                    }
                    Text(card.bio).font(.body)
                }
            }
            .padding()
            .foregroundColor(.white)
            HStack {
                Image("yes")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:150)
                    .opacity(Double(card.x/10 - 1))
                Spacer()
                Image("nope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:150)
                    .opacity(Double(card.x/10 * -1 - 1))
            }
            
        }
        .cornerRadius(8)
        .offset(x: card.x, y: card.y)
        .rotationEffect(.init(degrees: card.degree))
        .gesture (
            DragGesture()
                .onChanged { value in
                    withAnimation(.default) {
                        card.x = value.translation.width
                        // MARK: - BUG 5
                        card.y = value.translation.height
                        card.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                    }
                }
                .onEnded { (value) in
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                        switch value.translation.width {
                        case 0...100:
                            card.x = 0; card.degree = 0; card.y = 0
                        case let x where x > 100:
                            card.x = 500; card.degree = 12
                            swipeOutcome = 1
                            Task {
                                await sendRequest()
                            }// pass in the outcome parameter
                        case (-100)...(-1):
                            card.x = 0; card.degree = 0; card.y = 0
                        case let x where x < -100:
                            card.x  = -500; card.degree = -12
                            swipeOutcome = 0
                            Task {
                                await sendRequest()
                            }// pass in the outcome parameter
                        default:
                            card.x = 0; card.y = 0
                        }
                    }
                }
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        return CardView(card: Card.data[0])
            .previewLayout(.sizeThatFits)
    }
}

