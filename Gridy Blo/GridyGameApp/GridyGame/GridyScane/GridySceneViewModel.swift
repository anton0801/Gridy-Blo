import Foundation
import SpriteKit

extension Notification.Name {
    static let pauseGame = Notification.Name("PAUSE_GAME")
    static let loseGame = Notification.Name("LOSE_GAME")
    static let winGame = Notification.Name("WIN_GAME")
    static let nextLevel = Notification.Name("NEXT_LEVEL")
    static let prevLevel = Notification.Name("NEXT_LEVEL")
}

enum BlockColor: String {
    case red = "red"
    case blue = "blue"
}

class GridySceneViewModel {
    
    private var level: LevelItem
    
    private var gameField: [[SKSpriteNode?]] = []
    private var gameFieldValues: [[Int]] = []
    private let gameFieldColorValues = [
        "block_emp": 0,
        "block_blue": 1,
        "block_red": 2
    ]
    
    private var levelLabel: SKLabelNode!
    private var nextLevelBtn: SKSpriteNode!
    private var prevLevelBtn: SKSpriteNode!
    
    private var timeLabel: SKLabelNode!
    var time = 30 {
        didSet {
            timeLabel.text = time.formatSecondsToMinutesAndSeconds()
            if time == 0 {
//                if UserDefaults.standard.bool(forKey: "sounds_is_on") {
//                    addSoundEffect(for: .lose)
//                }
                if UserDefaults.standard.bool(forKey: "isVibrationEnabled") {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
               }
                NotificationCenter.default.post(name: .loseGame, object: nil, userInfo: nil)
            }
        }
    }
    
    private var blocksRedColorBtn: SKSpriteNode!
    private var blocksBlueColorBtn: SKSpriteNode!
    private var blocksEraserBtn: SKSpriteNode!
    private var gamePauseBtn: SKSpriteNode!
    
    private var tutorBack: SKSpriteNode!
    private var tutor1text: SKLabelNode!
    private var tutor2text: SKLabelNode!
    private var tutor3text: SKLabelNode!
    private var tutor4text: SKLabelNode!
    private var tutor5text: SKLabelNode!
    private var tutor6text: SKLabelNode!
    private var tutor7text: SKLabelNode!
    private var tutor8text: SKLabelNode!
    
    private var selectedColor: BlockColor? = nil
    
    private var eraserMode = false {
        didSet {
            if eraserMode {
                let actionScale = SKAction.scale(to: CGSize(width: 200, height: 180), duration: 0.2)
                blocksEraserBtn.run(actionScale)
            } else {
                let actionScale = SKAction.scale(to: CGSize(width: 180, height: 165), duration: 0.2)
                blocksEraserBtn.run(actionScale)
            }
        }
    }
    
    init(level: LevelItem) {
        self.level = level
    }
    
    func createGame(in scene: SKScene) {
        scene.size = CGSize(width: 750, height: 1335)
        makeBackgroundGame(in: scene)
        drawGameField(in: scene)
        makeGameTimer(in: scene)
        makeLevelLabel(in: scene)
        makePaintsAndEraser(in: scene)
        makePauseBtn(in: scene)
        if !UserDefaults.standard.bool(forKey: "is_tutor_showed") {
            makeTutor(in: scene)
            UserDefaults.standard.set(true, forKey: "is_tutor_showed")
        }
    }
    
    private func makeTutor(in scene: SKScene) {
        tutorBack = SKSpriteNode(color: .black, size: scene.size)
        tutorBack.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        tutorBack.zPosition = 9
        tutorBack.alpha = 0.5
        scene.addChild(tutorBack)
        
        tutor1text = SKLabelNode(text: "FILL IN ALL")
        tutor1text.fontName = "Jua-Regular"
        tutor1text.fontSize = 42
        tutor1text.fontColor = .white
        tutor1text.zPosition = 10
        tutor1text.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 400)
        scene.addChild(tutor1text)
        
        tutor2text = SKLabelNode(text: "BLOCKS ON THE FLOOR")
        tutor2text.fontName = "Jua-Regular"
        tutor2text.fontSize = 42
        tutor2text.fontColor = .white
        tutor2text.zPosition = 10
        tutor2text.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 440)
        scene.addChild(tutor2text)
        
        tutor3text = SKLabelNode(text: "IN TWO COLORS")
        tutor3text.fontName = "Jua-Regular"
        tutor3text.fontSize = 42
        tutor3text.fontColor = .white
        tutor3text.zPosition = 10
        tutor3text.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 480)
        scene.addChild(tutor3text)
        
        tutor4text = SKLabelNode(text: "THAT THE BLOCKS")
        tutor4text.fontName = "Jua-Regular"
        tutor4text.fontSize = 42
        tutor4text.fontColor = .white
        tutor4text.zPosition = 10
        tutor4text.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 520)
        scene.addChild(tutor4text)
        
        tutor5text = SKLabelNode(text: "SYMMETRICAL")
        tutor5text.fontName = "Jua-Regular"
        tutor5text.fontSize = 42
        tutor5text.fontColor = .white
        tutor5text.zPosition = 10
        tutor5text.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 560)
        scene.addChild(tutor5text)
        
        tutor6text = SKLabelNode(text: "YOU CAN USE AN ERASER")
        tutor6text.fontName = "Jua-Regular"
        tutor6text.fontSize = 42
        tutor6text.fontColor = .white
        tutor6text.zPosition = 10
        tutor6text.position = CGPoint(x: scene.size.width / 2, y: 350)
        scene.addChild(tutor6text)
        
        tutor7text = SKLabelNode(text: "TO CLEAN")
        tutor7text.fontName = "Jua-Regular"
        tutor7text.fontSize = 42
        tutor7text.fontColor = .white
        tutor7text.zPosition = 10
        tutor7text.position = CGPoint(x: scene.size.width / 2, y: 310)
        scene.addChild(tutor7text)
        
        tutor8text = SKLabelNode(text: "FROM THE BLOCK")
        tutor8text.fontName = "Jua-Regular"
        tutor8text.fontSize = 42
        tutor8text.fontColor = .white
        tutor8text.zPosition = 10
        tutor8text.position = CGPoint(x: scene.size.width / 2, y: 270)
        scene.addChild(tutor8text)
    }
    
    private func removeTutor() {
        let actionFade = SKAction.fadeOut(withDuration: 0.5)
        tutorBack.run(actionFade)
        tutor1text.run(actionFade)
        tutor2text.run(actionFade)
        tutor3text.run(actionFade)
        tutor4text.run(actionFade)
        tutor5text.run(actionFade)
        tutor6text.run(actionFade)
        tutor7text.run(actionFade)
        tutor8text.run(actionFade)
    }
    
    func observeTouches(in scene: SKScene, _ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: scene)
        let objectsInLocation = scene.nodes(at: location)
        
        if tutorBack != nil {
            if objectsInLocation.contains(tutorBack) {
                removeTutor()
                return
            }
        }
        
        if objectsInLocation.contains(gamePauseBtn) {
            pauseGame(in: scene)
            return
        }
        
        if objectsInLocation.contains(blocksBlueColorBtn) {
            selectColor(color: .blue, btn: blocksBlueColorBtn)
            return
        }
        
        if objectsInLocation.contains(blocksRedColorBtn) {
            selectColor(color: .red, btn: blocksRedColorBtn)
            return
        }
        
        if objectsInLocation.contains(blocksEraserBtn) {
            eraserModeToggle()
            return
        }
        
        if objectsInLocation.contains(prevLevelBtn) {
            if level.levelNum > 1 {
                NotificationCenter.default.post(name: .prevLevel, object: nil, userInfo: nil)
            }
            return
        }
        
        if objectsInLocation.contains(nextLevelBtn) {
            if LevelsRepository.nextLevelAvailable(currentLevel: level) {
                NotificationCenter.default.post(name: .nextLevel, object: nil, userInfo: nil)
            }
            return
        }
        
        for node in scene.nodes(at: location) {
            if node.name?.contains("block") == true {
                if tutorBack != nil {
                    removeTutor()
                }
                colorizeGameFieldItem(in: scene, node)
            }
        }
    }
    
    private func colorizeGameFieldItem(in scene: SKScene, _ node: SKNode) {
        if UserDefaults.standard.bool(forKey: "isVibrationEnabled") {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        var newBlockImage = "rect_blue"
        if selectedColor == .red {
            newBlockImage = "block_red"
        } else if selectedColor == nil {
            newBlockImage = "block_emp"
        } else {
            newBlockImage = "block_blue"
        }
        (node as! SKSpriteNode).texture = SKTexture(imageNamed: newBlockImage)
        let nodeNameComponents = node.name!.components(separatedBy: "_")
        let yIndex = Int(nodeNameComponents[1])!
        let xIndex = Int(nodeNameComponents[2])!
        gameFieldValues[yIndex][xIndex] = gameFieldColorValues[newBlockImage]!
        checkGame(in: scene)
    }
    
    private func checkGame(in scene: SKScene) {
        if isSymmetric(gameFieldValues) {
            makeGoodJob(in: scene)
            scene.isPaused = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: .winGame, object: nil, userInfo: nil)
            }
            if UserDefaults.standard.bool(forKey: "isVibrationEnabled") {
                 let generator = UINotificationFeedbackGenerator()
                 generator.notificationOccurred(.success)
            }
        }
   }
    
    private func makeGoodJob(in scene: SKScene) {
        let goodJob = SKLabelNode(text: "GOOD JOB!")
        goodJob.fontName = "Jua-Regular"
        goodJob.fontSize = 42
        goodJob.fontColor = .white
        goodJob.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 350)
        goodJob.zPosition = 12
        scene.addChild(goodJob)
    }
    
    func isSymmetric(_ a: [[Int]]) -> Bool {
        var array: [[Int]] = []
        for b in a {
            var row = [Int]()
            for j in b {
                if j != -1 {
                    row.append(j)
                }
            }
            array.append(row)
        }
        
        guard !array.isEmpty else {
            return false
        }
        
        if array == [[1], [1, 1, 1], [2], [2, 2, 2]] || array == [[2], [2, 2, 2], [1], [1, 1, 1]] ||
            array == [[2], [2, 2, 2], [1, 1, 1], [1]] || array == [[1], [1, 2, 2], [1, 1, 2], [2]] ||
            array == [[2], [2, 1, 1], [2, 2, 1], [1]] || array == [[1], [1, 1, 1], [2, 2, 2], [2]] || array == [[2, 2, 2], [1, 1, 1, 2], [1, 2, 2, 2], [1, 1, 1]] || array == [[1, 1, 1], [2, 2, 2, 1], [2, 1, 1, 1], [2, 2, 2]] {
            return true
        }
        
        let columnCount = array[0].count
        for row in array {
            if row.count != columnCount {
                return false
            }
        }
        
        let midpoint = columnCount / 2
        
        for row in array {
            for i in 0..<midpoint {
                if row[i] != row[columnCount - 1 - i] {
                    return false
                }
            }
        }
        
        for row in array {
            for i in 0..<row.count {
                if row[i] == 0 {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func eraserModeToggle() {
      eraserMode = !eraserMode
      selectedColor = nil
      selectColor(color: selectedColor, btn: nil)
  }
    
    private func selectColor(color: BlockColor?, btn: SKSpriteNode?) {
        if color == nil {
            let actionScale = SKAction.scale(to: CGSize(width: 180, height: 165), duration: 0.2)
            blocksBlueColorBtn.run(actionScale)
            blocksRedColorBtn.run(actionScale)
            return
        }
        
        let actionScale = SKAction.scale(to: CGSize(width: 180, height: 165), duration: 0.2)
        if selectedColor == .red {
            blocksRedColorBtn.run(actionScale)
        } else if selectedColor == .blue {
            blocksBlueColorBtn.run(actionScale)
        }
        
        if selectedColor == color {
            let actionScale = SKAction.scale(to: CGSize(width: 180, height: 165), duration: 0.2)
            btn?.run(actionScale)
            selectedColor = nil
        } else {
            let actionScale = SKAction.scale(to: CGSize(width: 200, height: 190), duration: 0.2)
            btn?.run(actionScale)
            selectedColor = color
        }
        
        eraserMode = false
    }
    
    private func pauseGame(in scene: SKScene) {
        scene.isPaused = true
        NotificationCenter.default.post(name: .pauseGame, object: nil, userInfo: nil)
    }
    
    private func makePauseBtn(in scene: SKScene) {
        gamePauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        gamePauseBtn.position = CGPoint(x: 80, y: scene.size.height - 130)
        gamePauseBtn.size = CGSize(width: 80, height: 70)
        scene.addChild(gamePauseBtn)
    }
    
    private func makePaintsAndEraser(in scene: SKScene) {
        let backColor = SKSpriteNode(color: .black, size: CGSize(width: scene.size.width, height: 230))
        backColor.alpha = 0.4
        backColor.position = CGPoint(x: scene.size.width / 2, y: 115)
        scene.addChild(backColor)
        
        blocksRedColorBtn = SKSpriteNode(imageNamed: "item_blocks_red")
        blocksRedColorBtn.position = CGPoint(x: scene.size.width / 2 - 200, y: 110)
        blocksRedColorBtn.name = "blocks_red"
        blocksRedColorBtn.size = CGSize(width: 180, height: 165)
        blocksRedColorBtn.zPosition = 10
        scene.addChild(blocksRedColorBtn)
        
        blocksBlueColorBtn = SKSpriteNode(imageNamed: "item_blocks_blue")
        blocksBlueColorBtn.position = CGPoint(x: scene.size.width / 2, y: 110)
        blocksBlueColorBtn.name = "blocks_blue"
        blocksBlueColorBtn.size = CGSize(width: 180, height: 165)
        blocksBlueColorBtn.zPosition = 10
        scene.addChild(blocksBlueColorBtn)
        
        blocksEraserBtn = SKSpriteNode(imageNamed: "item_eraser")
        blocksEraserBtn.position = CGPoint(x: scene.size.width / 2 + 200, y: 110)
        blocksEraserBtn.name = "ereser"
        blocksEraserBtn.size = CGSize(width: 180, height: 165)
        blocksEraserBtn.zPosition = 10
        scene.addChild(blocksEraserBtn)
    }
    
    private func makeLevelLabel(in scene: SKScene) {
        let levelBack = SKSpriteNode(imageNamed: "level_bg")
        levelBack.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 150)
        levelBack.size = CGSize(width: 280, height: 80)
        scene.addChild(levelBack)
        
        levelLabel = SKLabelNode(text: "\(level.levelNum)")
        levelLabel.fontName = "Jua-Regular"
        levelLabel.fontSize = 42
        levelLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 160)
        scene.addChild(levelLabel)
        
        prevLevelBtn = SKSpriteNode(imageNamed: "prev_level")
        prevLevelBtn.position = CGPoint(x: scene.size.width / 2 - 90, y: scene.size.height - 145)
        if level.levelNum == 1 {
            prevLevelBtn.alpha = 0.6
        }
        // scene.addChild(prevLevelBtn)
        
        nextLevelBtn = SKSpriteNode(imageNamed: "next_level")
        nextLevelBtn.position = CGPoint(x: scene.size.width / 2 + 90, y: scene.size.height - 145)
        if level.levelNum == LevelsRepository.levelsNum || !LevelsRepository.nextLevelAvailable(currentLevel: level) {
            nextLevelBtn.alpha = 0.6
        }
        // scene.addChild(nextLevelBtn)
    }
    
    private func makeGameTimer(in scene: SKScene) {
        timeLabel = SKLabelNode(text: time.formatSecondsToMinutesAndSeconds())
        timeLabel.fontName = "Jua-Regular"
        timeLabel.fontSize = 72
        timeLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 280)
        scene.addChild(timeLabel)
    }
    
    private func makeBackgroundGame(in scene: SKScene) {
        let blackBack = SKSpriteNode(color: .black, size: scene.size)
        blackBack.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addChild(blackBack)
        
        let imageBack = SKSpriteNode(imageNamed: "bg")
        imageBack.size = scene.size
        imageBack.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        imageBack.alpha = 0.8
        scene.addChild(imageBack)
    }
    
    private func drawGameField(in scene: SKScene) {
        for (yIndex, row) in level.levelStructure.enumerated() {
            var rowField = [SKSpriteNode?]()
            var rowFieldValues: [Int] = []
            for (xIndex, item) in row.enumerated() {
                if item == 1 {
                    let x = scene.size.width - CGFloat(100 * (xIndex + 2))
                    let y = scene.size.height / 1.7 - CGFloat(85 * (yIndex + 1))
                    let node = SKSpriteNode(imageNamed: "block_emp")
                    node.position = CGPoint(x: x, y: y)
                    node.size = CGSize(width: 100, height: 85)
                    node.name = "block_\(yIndex)_\(xIndex)"
                    node.zPosition = 10
                    scene.addChild(node)
                    rowField.append(node)
                    rowFieldValues.append(0)
                } else {
                    rowField.append(nil)
                    rowFieldValues.append(-1)
                }
            }
            gameFieldValues.append(rowFieldValues)
            gameField.append(rowField)
        }
    }
    
}
