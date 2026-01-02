import SwiftUI


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum AnimationMode: String, CaseIterable {
    case drop, fadeOut
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
}

struct DisplayedPrismConfiguration: Identifiable {
    let id = UUID()
    var configuration: PrismConfiguration
    var fillColor: Color
    var trackingColor: Color
    var isBombColor: Bool
}






class GameModel: ObservableObject {
    var gridSize: Int
    
    @Published var board: [[DisplayedPrismConfiguration]] = []
    @Published var currentStep: Int = 0
    @Published var stepLimit: Int = 0
    @Published var bestMoves: [Color] = []
    var showBestMoves: Bool = false
    @Published var timeLimit: Int = 0
    var gameStarted: Bool = false
    
    
    
    var isAnimating: Bool = false
    
    var showTime: Bool = false
    
    
    
    var visitedCells = Set<Coordinate>()
    
    var PreColorBoard: [[Color]] = []
    var standardColors: [Color] = [.Red, .Blue, .Green, .Orange, .Purple, .Gray, .Brown, .Cyan]
    var availableColors: [Color] = [.Red, .Blue, .Green, .Orange, .Purple, .Gray, .Brown, .Cyan] {
        didSet {
            ColorSettings.shared.availableColorsEncoded = encodeColors(availableColors)
        }
    }
    var dizzyColors: [[Color]] = []
    @Published var currentColorBoard: [Color] = [.Red, .Blue, .Green, .Orange, .Purple, .Gray, .Brown, .Cyan]
    var currentColor: Color?
    

    let defaultLength = CGFloat(60)
    let defaultExtrusion = CGFloat(40)
    let defaultLevitaion = CGFloat(40)
    let defaultShawdowOpacity = CGFloat(0.4)
    
    let bombDirections = [
        ( 0, -1), ( 1, -1), ( 1,  0), ( 1,  1),
        ( 0,  1), (-1,  1), (-1,  0), (-1, -1)
    ]
    
    
    var dropEffectCoordinate: [[Coordinate]] = []
    var fadingEffectCoordinate: [(x: Int, y: Int)] = []
    var numberEffectCoordinate: [[Coordinate]] = []
    
    
    init(gridSize: Int) {
        self.gridSize = gridSize
//        UserDefaults.standard.removeObject(forKey: "availableColorsEncode")

        loadColors()
        
        initDizzyColors()
        initDropEffect()
        initFadeOutAndRestoreEffect()
        
        initGame()
    }

    
    // MARK: load / decode / encode available colors
    func encodeColors(_ colors: [Color]) -> String {
        let codableColors = colors.map { CodableColor(color: $0) }
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(codableColors),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return ""
    }
    
    
    func decodeColors(from string: String) -> [Color] {
        let decoder = JSONDecoder()
        if let data = string.data(using: .utf8),
           let codableColors = try? decoder.decode([CodableColor].self, from: data) {
            return codableColors.map { $0.color }
        }
        return []
    }
    
    
    func loadColors() {
        let decoded = decodeColors(from: ColorSettings.shared.availableColorsEncoded)
        if decoded.isEmpty {
            ColorSettings.shared.availableColorsEncoded = encodeColors(availableColors)
        } else {
            availableColors = decoded
            currentColorBoard = availableColors
        }
    }

    
    
    
    
    // MARK: VICTORY CHECKING
    func checkWinCondition(gameLevel: GameLevel) {
        isAnimating = true
        let firstColor = board[0][0].trackingColor
        for row in board {
            for cell in row {
                if cell.trackingColor != firstColor {
                    isAnimating = false
                    return
                }
            }
        }
        
        gameStarted = false
        
        
        if gameLevel.timerPlaying {
            gameLevel.pauseTimer()
        }
        
        if currentStep <= stepLimit && !showBestMoves {
            let currentBonus = (gameLevel.currentMode == .dizzy) ? 3 : (gameLevel.currentMode == .normal) ? 1 : 0
            gameLevel.currentCoin += (currentBonus + ((gridSize - 8) / 2))
            if gameLevel.timer && gameLevel.currentTime <= timeLimit {
                gameLevel.currentCoin += currentBonus * 2
            }
        }
        showBestMoves = false
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animateNumberAnimation(number: self.currentStep, fillColor: self.board[0][0].trackingColor)
            self.resetPreColorBoard()
            self.solveBoard()
            self.visitedCells = []
            self.currentStep = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                self.isAnimating = false
                self.animateDropEffect(timer: gameLevel.timer)
            }
        }
    }
    
    
    // MARK: Custom Completed
    func completedCustom() -> Int {
        var notSetColor = true
        var setAll = true
        var errorOccur = false
        
        for row in board {
            for cell in row {
                if !(cell.fillColor == .lightGray) {
                    notSetColor = false
                } else {setAll = false}
                
                if !currentColorBoard.contains(cell.fillColor) {
                    errorOccur = true
                }
            }
        }
        
        if notSetColor {
            // Chua duoc to o nao ca!
            currentColor = nil
            return 0
        } else if setAll && !errorOccur {
            // Da duoc to het!
            currentColor = nil
            solveBoard()
            setTimeLimit()
            return 1
        }
        return -1
    }


    // MARK: SELECT COLOR
    func selectColor(_ color: Color, gameLevel: GameLevel) {
        if gameLevel.currentMode == .custom {
            if currentColor == color {currentColor = nil}
            else {currentColor = color}
        }
        else if !isAnimating {
            let targetColor = board[0][0].trackingColor
            if color != targetColor {
                if !gameStarted {
                    gameStarted = true
                }
                
                if gameLevel.timer && !gameLevel.timerPlaying {
                    gameLevel.playTimer()
                }
                    
                withAnimation(.easeInOut(duration: 0.2)) {
                    currentStep += 1
                }
                
                floodFill(x: 0, y: 0, targetColor: targetColor, replacementColor: color)
                animateFloodFill(from: (x: 0, y: 0))
                checkWinCondition(gameLevel: gameLevel)
            }
        }
    }
    
    
//    func showSolution(gameLevel: GameLevel) {
//        showBestMoves = true
//        for (index, move) in bestMoves.enumerated() {
//            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index) * 1.5)) {
//                guard self.showBestMoves else { return }
//                self.selectColor(move, gameLevel: gameLevel)
//            }
//        }
//    }
    func showSolution(gameLevel: GameLevel) {
        let timeInterval = 1.5 * (Double(gridSize) / 8)
        showBestMoves = true
        var index = 0

        self.selectColor(self.bestMoves[index], gameLevel: gameLevel)
        index += 1
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            guard self.showBestMoves && !(index >= self.bestMoves.count) else {
                timer.invalidate()
                return
            }

            self.selectColor(self.bestMoves[index], gameLevel: gameLevel)
            index += 1
        }
    }
//    func showSolution(gameLevel: GameLevel) {
//        Task {
//            showBestMoves = true
//            for move in bestMoves {
//                guard showBestMoves else { break }
//                selectColor(move, gameLevel: gameLevel)
//                try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.7s
//            }
//        }
//    }


    
    
    
    
    // MARK: MAIN FLOOD
    func floodFill(x: Int, y: Int, targetColor: Color, replacementColor: Color) {
        var queue = [(x, y)]
        var visited = Set<Coordinate>()
        
        while !queue.isEmpty {
            let (x, y) = queue.removeFirst()
            guard x >= 0, y >= 0, x < gridSize, y < gridSize else { continue }
            guard board[y][x].trackingColor == targetColor else { continue }
            guard !visited.contains(Coordinate(x: x, y: y)) else { continue }

            board[y][x].trackingColor = replacementColor
            
            visited.insert(Coordinate(x: x, y: y))
            
            queue.append((x + 1, y))
            queue.append((x - 1, y))
            queue.append((x, y + 1))
            queue.append((x, y - 1))
        }
    }
}


