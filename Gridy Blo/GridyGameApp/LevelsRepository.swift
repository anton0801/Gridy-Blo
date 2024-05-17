import Foundation

struct LevelItem {
    var id: String
    var levelNum: Int
    var levelStructure: [[Int]]
}

class LevelsRepository: ObservableObject {
    
    var allLevels = [
            LevelItem(id: "level_1", levelNum: 1, levelStructure: [
                [0, 0, 1, 0, 0],
                [1, 1, 1, 0, 0],
                [0, 0, 1, 0, 0],
                [0, 0, 1, 1, 1],
            ]),
            LevelItem(id: "level_2", levelNum: 2, levelStructure: [
                [0, 1, 0, 0, 0],
                [0, 1, 1, 1, 0],
                [0, 1, 1, 1, 0],
                [0, 0, 0, 1, 0],
            ]),
            LevelItem(id: "level_3", levelNum: 3, levelStructure: [
                [1, 0, 0, 0, 0, 0],
                [1, 1, 1, 0, 0, 0],
                [0, 1, 1, 1, 0, 0],
                [0, 1, 0, 0, 0, 0],
            ]),
            LevelItem(id: "level_4", levelNum: 4, levelStructure: [
                [0, 0, 1, 1, 1, 0],
                [1, 1, 1, 0, 1, 0],
                [1, 0, 1, 1, 1, 0],
                [1, 1, 1, 0, 0, 0],
            ]),
            LevelItem(id: "level_5", levelNum: 5, levelStructure: [
                [1, 0, 0, 0, 0, 0],
               [1, 1, 1, 1, 0, 0],
               [1, 1, 1, 1, 0, 0],
               [1, 0, 0, 0, 0, 0],
              ]),
            LevelItem(id: "level_6", levelNum: 6, levelStructure: [
                [1, 0, 0, 0, 0, 0],
               [1, 1, 1, 0, 0, 0],
               [0, 1, 1, 1, 0, 0],
               [0, 1, 0, 0, 0, 0],
              ]),
            LevelItem(id: "level_7", levelNum: 7, levelStructure:[
                [1, 1, 1, 1, 0, 0],
              [1, 1, 1, 1, 0, 0],
              [0, 0, 1, 1, 0, 0],
                [0,0,0,0,0,0]
             ]),
            LevelItem(id: "level_8", levelNum: 8, levelStructure: [
                [0, 0, 1, 1, 1, 0],
               [1, 1, 1, 0, 1, 0],
               [1, 0, 1, 1, 1, 0],
               [1, 1, 1, 0, 0, 0],
              ]),
            LevelItem(id: "level_9", levelNum: 9, levelStructure: [
                [0, 1, 0, 0, 0, 0],
               [1, 1, 0, 0, 0, 0],
               [0, 1, 1, 0, 0, 0],
               [0, 1, 0, 0, 0, 0],
              ]),
            LevelItem(id: "level_10", levelNum: 10, levelStructure:  [
                [0, 1, 0, 0, 0],
                [0, 1, 1, 1, 0],
                [0, 1, 1, 1, 0],
                [0, 0, 0, 1, 0],
            ]),
        ]
    @Published var unlockedLevelIds: [String] = [] {
        didSet {
            UserDefaults.standard.set(unlockedLevelIds.joined(separator: ","), forKey: "available_levels")
        }
    }
    static let levelsNum = 5
    
    init() {
        if unlockedLevelIds.isEmpty {
            unlockedLevelIds = ["level_1"]
        }
    }
    
    @Published var currentLevelNum = UserDefaults.standard.integer(forKey: "current_level") {
        didSet {
            UserDefaults.standard.set(currentLevelNum, forKey: "current_level")
        }
    }
    
    func setUpInFirstLaunch() {
        if !UserDefaults.standard.bool(forKey: "levels_set_up") {
            unlockedLevelIds = ["level_1"]
            currentLevelNum = 1
            UserDefaults.standard.set(true, forKey: "levels_set_up")
        }
    }
    
    func getCurrentLevelItem() -> LevelItem {
        return allLevels.filter { $0.levelNum == currentLevelNum }[0]
    }
    
    func obtainLevelsUnlocked() {
        let unlocked = UserDefaults.standard.string(forKey: "available_levels") ?? "level_1,"
        let components = unlocked.components(separatedBy: ",")
        for levelId in components {
            unlockedLevelIds.append(levelId)
        }
    }
    
    func unlockNextLevel(currentLevel: Int) {
        let nextLevelNum = currentLevel + 1
        if nextLevelNum <= allLevels.count {
            unlockedLevelIds.append("level_\(nextLevelNum)")
            UserDefaults.standard.set(unlockedLevelIds.joined(separator: ","), forKey: "available_levels")
        }
    }
    
    func nextLevelIsAvailable(currentLevel: Int) -> Bool {
        let nextLevelNum = currentLevel + 1
        if unlockedLevelIds.contains("level_\(currentLevel)") {
            return true
        }
        return false
    }
    
    func getLevelItemByNum(neededLevel: Int) -> LevelItem? {
        if neededLevel > 0 {
            return allLevels.filter { $0.levelNum == neededLevel }[0]
        }
        return nil
    }
    
    static func nextLevelAvailable(currentLevel: LevelItem) -> Bool {
        let nextLevelNum = currentLevel.levelNum + 1
        let unlockedLevelIdsS = UserDefaults.standard.string(forKey: "available_levels")?.components(separatedBy: ",") ?? []
        if unlockedLevelIdsS.contains("level_\(nextLevelNum)") {
            return true
        }
        return false
    }
    
}
