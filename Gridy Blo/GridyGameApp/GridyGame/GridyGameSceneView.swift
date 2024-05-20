import SwiftUI
import SpriteKit

struct GridyGameSceneView: View {
    
    @EnvironmentObject var levelsRepository: LevelsRepository
    @EnvironmentObject var livesRepository: LivesRepository
    
    @State var isGamePaused = false
    @State var isGameWin = false
    @State var isGameLose = false
    
    @State var gridyGameScene: GridySceneGame?
    
    var body: some View {
        ZStack {
            if gridyGameScene != nil {
                SpriteView(scene: gridyGameScene!)
                      .ignoresSafeArea()
                      .onReceive(NotificationCenter.default.publisher(for: .pauseGame)) { _ in
                          withAnimation {
                              isGamePaused = true
                          }
                      }
                      .onReceive(NotificationCenter.default.publisher(for: .loseGame)) { _ in
                          livesRepository.livesAvailable -= 1
                          gridyGameScene?.finishGame()
                          withAnimation {
                              isGameLose = true
                          }
                      }
                      .onReceive(NotificationCenter.default.publisher(for: .winGame)) { _ in
                          gridyGameScene?.finishGame()
                          levelsRepository.unlockNextLevel(currentLevel: levelsRepository.currentLevelNum)
                          livesRepository.livesAvailable -= 1
                          withAnimation {
                              isGameWin = true
                          }
                      }
                      .onReceive(NotificationCenter.default.publisher(for: .nextLevel)) { _ in
                          gridyGameScene?.finishGame()
                          if levelsRepository.nextLevelIsAvailable(currentLevel: levelsRepository.currentLevelNum) {
                              levelsRepository.currentLevelNum += 1
                              gridyGameScene = gridyGameScene!.restartGame(levelsRepositoryNew: levelsRepository)
                          }
                      }
                      .onReceive(NotificationCenter.default.publisher(for: .prevLevel)) { _ in
                            gridyGameScene?.finishGame()
                            if levelsRepository.getCurrentLevelItem().levelNum > 1 {
                                levelsRepository.currentLevelNum = levelsRepository.currentLevelNum - 1
                                gridyGameScene = gridyGameScene!.restartGame(levelsRepositoryNew: levelsRepository)
                            }
                      }
            }
            
            if isGamePaused {
                GamePauseStateView(restartAction: {
                    gridyGameScene?.finishGame()
                    gridyGameScene = gridyGameScene!.restartGame(levelsRepositoryNew: levelsRepository)
                    withAnimation {
                        isGamePaused = false
                    }
                }, continuePlay: {
                    withAnimation {
                        isGamePaused = false
                    }
                    gridyGameScene!.continuePlay()
                })
            } else if isGameWin {
                GameWinStateView(restartAction: {
                    gridyGameScene?.finishGame()
                    gridyGameScene = gridyGameScene!.restartGame(levelsRepositoryNew: levelsRepository)
                    withAnimation {
                        isGamePaused = false
                    }
                }, nextLevelAction: {
                    levelsRepository.currentLevelNum += 1
                    gridyGameScene = gridyGameScene!.restartGame(levelsRepositoryNew: levelsRepository)
                    withAnimation {
                        isGameWin = false
                    }
                })
                .environmentObject(livesRepository)
            } else if isGameLose {
                GameLoseStateView(restartAction: {
                    gridyGameScene?.finishGame()
                    gridyGameScene = gridyGameScene!.restartGame(levelsRepositoryNew: levelsRepository)
                    withAnimation {
                        isGamePaused = false
                    }
                })
            }
        }
        .onAppear {
            gridyGameScene = GridySceneGame(size: CGSize(width: 750, height: 1335), levelsRepository: levelsRepository)
        }
    }
}

#Preview {
    GridyGameSceneView()
        .environmentObject(LevelsRepository())
        .environmentObject(LivesRepository())
}
