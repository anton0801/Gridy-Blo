import Foundation
import SpriteKit
import SwiftUI

class GridySceneGame: SKScene {
    
    private var gridySceneViewModel: GridySceneViewModel!
    private var levelsRepository: LevelsRepository
    
    private var gameTimer: Timer = Timer()
    
    init(size: CGSize, levelsRepository: LevelsRepository) {
        self.levelsRepository = levelsRepository
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var level: LevelItem!
    
    override func didMove(to view: SKView) {
        level = levelsRepository.getCurrentLevelItem()
        print(level)
        gridySceneViewModel = GridySceneViewModel(level: level)
        gridySceneViewModel.createGame(in: self)
        
        gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeMinus), userInfo: nil, repeats: true)
    }
    
    @objc private func timeMinus() {
        if !isPaused {
            gridySceneViewModel.time -= 1
        }
    }
    
    func continuePlay() {
        isPaused = false
    }
    
    func restartGame(levelsRepositoryNew: LevelsRepository) -> GridySceneGame {
        let newGameScene = GridySceneGame(size: size, levelsRepository: levelsRepositoryNew)
        view?.presentScene(newGameScene)
        return newGameScene
    }
    
    func finishGame() {
        gameTimer.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gridySceneViewModel.observeTouches(in: self, touches, with: event)
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: GridySceneGame(size: CGSize(width: 750, height: 1335), levelsRepository: LevelsRepository()))
            .ignoresSafeArea()
    }
}
