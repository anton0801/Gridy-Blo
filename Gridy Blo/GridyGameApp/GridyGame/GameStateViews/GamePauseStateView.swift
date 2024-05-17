import SwiftUI

struct GamePauseStateView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var restartAction: () -> Void
    var continuePlay: () -> Void
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("PAUSE")
                .font(.custom("Jua-Regular", size: 42))
                .foregroundColor(.white)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 1)
            
            Spacer()
            
            Text("GAME PAUSED")
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
                    continuePlay()
                } label: {
                    Image("continue_play_btn")
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
            }
            
            Spacer()
            Spacer()
        }
        .background(
            Image("bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        )
        .preferredColorScheme(.dark)
    }
}

#Preview {
    GamePauseStateView(restartAction: { }, continuePlay: { })
}
