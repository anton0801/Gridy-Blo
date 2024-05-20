import SwiftUI

struct HomeView: View {
    
    @StateObject var livesRepository: LivesRepository = LivesRepository()
    @State var settingsRepository: SettingsRepository = SettingsRepository()
    @State var levelsRepository: LevelsRepository = LevelsRepository()
    
    @State var timeToUnlockNextHeart = -1
    
    @State var errorPlayLivesNo = false
    
    func formattedTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
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
                        Text(self.formattedTime(time: livesRepository.timeRemaining))
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
                        if livesRepository.livesAvailable > 0 {
                            NavigationLink(destination: GridyGameSceneView()
                                .environmentObject(livesRepository)
                                .environmentObject(levelsRepository)
                                .navigationBarBackButtonHidden(true)) {
                                    Image("play_btn")
                                }
                        } else {
                            Button {
                                errorPlayLivesNo = true
                            } label: {
                                Image("play_btn")
                            }
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
                
            }
            .alert(isPresented: $errorPlayLivesNo) {
                Alert(
                    title: Text("Warning!"),
                    message: Text("Sorry, but you don't have lives to play with, come back when lives are restored."),
                    dismissButton: .default(Text("OK!"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func calculateLives() {
        let currentDate = Date()
        
        let defaults = UserDefaults.standard
        if let lastDate = defaults.object(forKey: "live_minus_last_date") as? Date {
            let timeInterval = currentDate.timeIntervalSince(lastDate)
            let minutesPassed = Int(timeInterval / 60)
            
            var livesToAdd = 0
            if minutesPassed >= 90 {
                livesToAdd = 3
            } else if minutesPassed >= 60 {
                livesToAdd = 2
            } else if minutesPassed >= 30 {
                livesToAdd = 1
            }
            
            if livesToAdd > 0 {
                livesRepository.livesAvailable += livesToAdd
                if livesRepository.livesAvailable > 3 {
                    livesRepository.livesAvailable = 3
                }
                defaults.set(nil, forKey: "lastUpdateDate")
            }
        } else {
            defaults.set(currentDate, forKey: "lastUpdateDate")
        }
    }
    
}

#Preview {
    HomeView()
}
