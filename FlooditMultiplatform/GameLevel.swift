//
//  GameLevel.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 21/01/2025.
//

import SwiftUI

enum GameMode: String, CaseIterable {
    case normal
    case dizzy
    case custom
}

enum GameLevelCase: String, CaseIterable {
    case easy
    case medium
    case hard
}

//class ColorSettings: ObservableObject {
//    @Published var availableColorsEncoded: String {
//        didSet {
//            UserDefaults.standard.set(availableColorsEncoded, forKey: "availableColorsEncode")
//        }
//    }
//
//    init() {
//        self.availableColorsEncoded = UserDefaults.standard.string(forKey: "availableColorsEncode") ?? ""
//    }
//}
class ColorSettings: ObservableObject {
    static let shared = ColorSettings()

    @Published var availableColorsEncoded: String {
        didSet {
            UserDefaults.standard.set(availableColorsEncoded, forKey: "availableColorsEncode")
        }
    }

    init() {
        self.availableColorsEncoded = UserDefaults.standard.string(forKey: "availableColorsEncode") ?? ""
    }
}



class GameLevel: ObservableObject {
    @Published var currentBoardType = GameModel(gridSize: 8)
    var easyBoardType = GameModel(gridSize: 8)
    var mediumBoardType = GameModel(gridSize: 10)
    var hardBoardType = GameModel(gridSize: 12)
    
    @Published var currentMode: GameMode = .normal
    @Published var previousMode: GameMode = .normal
    
    @Published var timer: Bool = false
    @Published var timerPlaying: Bool = false
    @Published var currentTime: Int = 0
    var count: Timer?
    
    @AppStorage("currentCoin") var currentCoin: Int = 0
    @AppStorage("bombColor") var bombColor: Int = 0
    @Published var isSettingBomb: Bool = false
    
    func switchLevel(level: GameLevelCase) {
        if !currentBoardType.isAnimating {
            switch level {
            case .easy:
                if currentBoardType.gridSize != 8 {
                    currentBoardType.animateDropEffect(endingAnimate: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.currentBoardType = self.easyBoardType
                    }
                }
            case .medium:
                if currentBoardType.gridSize != 10 {
                    currentBoardType.animateDropEffect(endingAnimate: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.currentBoardType = self.mediumBoardType
                    }
                }
            case .hard:
                if currentBoardType.gridSize != 12 {
                    currentBoardType.animateDropEffect(endingAnimate: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.currentBoardType = self.hardBoardType
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                currentBoardType.loadColors()
                for y in (0..<currentBoardType.gridSize) {
                    for x in (0..<currentBoardType.gridSize) {
                        currentBoardType.board[y][x].configuration.levitation = 0
                        currentBoardType.board[y][x].configuration.extrusion = 10
                        currentBoardType.board[y][x].fillColor = .clear
                        currentBoardType.board[y][x].configuration.shadowColor = .clear
                    }
                }

                currentBoardType.resetGame(gameMode: currentMode, animationMode: .drop, beginningAnimate: false)
            }
        }
    }
    
    func switchMode(to mode: GameMode) {
        previousMode = currentMode
        withAnimation(.easeInOut(duration: 0.2)) {
            currentMode = mode
        }
        currentBoardType.resetGame(gameMode: currentMode, animationMode: .drop)
    }
    
    
    func playTimer() {
        guard !timerPlaying else { return }
        timerPlaying = true
        count = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentTime += 1
        }
    }
    
    func pauseTimer() {
        timerPlaying = false
        count?.invalidate()
    }
    
    func resetTimer() {
        pauseTimer()
        withAnimation(.easeInOut(duration: 0.3)) {
            currentTime = 0
        }
    }
}





struct GameLevel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
