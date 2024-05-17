import SwiftUI

struct GridySettingsGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsRepository: SettingsRepository
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    goBack()
                } label: {
                    Image("ic_home")
                }
                
                Spacer()
            }
            .padding()
            
            Text("SETTINGS")
                   .font(.custom("Jua-Regular", size: 64))
                   .foregroundColor(.white)
                   .shadow(color: .black, radius: 1)
            Spacer()
            
            VStack {
                HStack {
                    Button {
                        settingsRepository.isMusicEnabled = !settingsRepository.isMusicEnabled
                        if settingsRepository.isVibrationEnabled {
                           triggerHapticFeedback()
                       }
                    } label: {
                        Image("ic_music")
                            .opacity(settingsRepository.isMusicEnabled ? 1 : 0.6)
                    }
                    
                    Spacer().frame(width: 40)
                    
                    Button {
                        settingsRepository.isSoundsEnabled = !settingsRepository.isSoundsEnabled
                        if settingsRepository.isVibrationEnabled {
                           triggerHapticFeedback()
                       }
                    } label: {
                        Image("ic_sounds")
                            .opacity(settingsRepository.isSoundsEnabled ? 1 : 0.6)
                    }
                }
                Spacer().frame(height: 20)
                Button {
                    settingsRepository.isVibrationEnabled = !settingsRepository.isVibrationEnabled
                    if settingsRepository.isVibrationEnabled {
                        triggerHapticFeedback()
                    }
                } label: {
                    Image("ic_vibrations")
                        .opacity(settingsRepository.isVibrationEnabled ? 1 : 0.6)
                }
            }
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
    
    private func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
}

#Preview {
    GridySettingsGameView()
        .environmentObject(SettingsRepository())
}
