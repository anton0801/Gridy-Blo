import SwiftUI

struct HomeView: View {
    
    @State var livesRepository: LivesRepository = LivesRepository()
    @State var settingsRepository: SettingsRepository = SettingsRepository()
    @State var levelsRepository: LevelsRepository = LevelsRepository()
    
    @State var timeToUnlockNextHeart = -1
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        ForEach(1...3, id: \.self) { live in
                            if live <= livesRepository.livesAvailable {
                                Image("heart")
                            } else {
                                Image("heart")
                                    .opacity(0.6)
                            }
                        }
                    }
                    if livesRepository.livesAvailable < 3 {
                        Text(timeToUnlockNextHeart.formatSecondsToMinutesAndSeconds())
                            .font(.custom("Jua-Regular", size: 32))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 1)
                    }
                }
                
                Image("men")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                ZStack {
                    VStack {
                        NavigationLink(destination: GridyGameSceneView()
                            .environmentObject(livesRepository)
                            .environmentObject(levelsRepository)
                            .navigationBarBackButtonHidden(true)) {
                                Image("play_btn")
                            }
                        
                        NavigationLink(destination: GridySettingsGameView()
                            .environmentObject(settingsRepository)
                            .navigationBarBackButtonHidden(true)) {
                                Image("settings_btn")
                            }
                        
                        Button {
                            exit(0)
                        } label: {
                            Image("quit_btn")
                        }
                    }
                    
                    Image("plane_blue")
                        .offset(x: -100, y: 150)
                    
                    Image("plane_red")
                        .offset(x: 110, y: -170)
                }
                .offset(y: -20)
            }
            .background(
                Image("bg")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.85)
            )
            .preferredColorScheme(.dark)
            .onAppear {
                levelsRepository.setUpInFirstLaunch()
                print(levelsRepository.currentLevelNum)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeView()
}
