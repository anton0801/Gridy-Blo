import SwiftUI

struct GameWinStateView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var livesRepository: LivesRepository

    var restartAction: () -> Void
    var nextLevelAction: () -> Void
    
    var body: some View {
        VStack {
                    
            Spacer()
            
            Text("YOU WIN")
                .font(.custom("Jua-Regular", size: 42))
                .foregroundColor(.white)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 1)
            
            Spacer()
            
            Text("CONGRATULATIONS!")
                .font(.custom("Jua-Regular", size: 28))
                .foregroundColor(.white)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 1)
            
            Spacer()
            
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("ic_home")
                        .resizable()
                        .frame(width: 110, height: 110)
                }
                
                Button {
                    restartAction()
                } label: {
                    Image("restart_btn")
                        .resizable()
                        .frame(width: 110, height: 110)
                }
                
                if livesRepository.livesAvailable > 0 {
                    Button {
                        nextLevelAction()
                    } label: {
                        Image("next_level_btn")
                            .resizable()
                            .frame(width: 110, height: 110)
                    }
                }
            }
            
            Spacer()
            Spacer()
        }
        .background(
            Image("bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.85)
        )
        .preferredColorScheme(.dark)
    }
}

#Preview {
    GameWinStateView(restartAction: {}, nextLevelAction: {})
}
