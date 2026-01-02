//
//  InitAnimation.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 02/02/2025.
//

import Foundation


extension GameModel {
    // MARK: INIT EFFECT COORDINATION
    func initDropEffect() {
        let maxLayer = (gridSize + 1) / 2  // Số vòng lan ra

        // Tạo các lớp từ ngoài vào trong
        for layer in 0..<maxLayer {
            var currentLayer: [Coordinate] = []

            // Vòng trên và vòng dưới
            for x in layer..<(gridSize - layer) {
                currentLayer.append(Coordinate(x: x, y: layer)) // Hàng trên
                currentLayer.append(Coordinate(x: x, y: gridSize - layer - 1)) // Hàng dưới
            }

            // Vòng trái và vòng phải
            for y in (layer + 1)..<(gridSize - layer - 1) {
                currentLayer.append(Coordinate(x: layer, y: y)) // Cột trái
                currentLayer.append(Coordinate(x: gridSize - layer - 1, y: y)) // Cột phải
            }

            dropEffectCoordinate.append(currentLayer)
        }
    }
    
    func initFadeOutAndRestoreEffect() {
        // Tạo danh sách các ô theo dạng xoắn ốc từ ngoài vào trong
        var visited = Set<Coordinate>()
        var x = 0, y = 0
        let directions = [(1, 0), (0, 1), (-1, 0), (0, -1)] // Right, Down, Left, Up
        var directionIndex = 0
        let totalCells = gridSize * gridSize
        
        for _ in 0..<totalCells {
            fadingEffectCoordinate.append((x, y))
            visited.insert(Coordinate(x: x, y: y))
            
            let nextX = x + directions[directionIndex].0
            let nextY = y + directions[directionIndex].1
            
            if nextX >= 0, nextX < gridSize, nextY >= 0, nextY < gridSize, !visited.contains(Coordinate(x: nextX, y: nextY)) {
                x = nextX
                y = nextY
            } else {
                directionIndex = (directionIndex + 1) % 4
                x += directions[directionIndex].0
                y += directions[directionIndex].1
            }
        }
    }
    
    func initNumberAnimation(for number: Int) -> [Coordinate] {
        // Định nghĩa các mẫu (pattern) cho từng chữ số và dấu trừ theo dạng chuỗi,
        // trong đó '#' biểu thị ô được "sáng" và ' ' là ô trống.
        let digitPatterns: [Character: [String]] = [
            "0": [
                "###",
                "# #",
                "# #",
                "# #",
                "###"
            ],
            "1": [
                "  #",
                "  #",
                "  #",
                "  #",
                "  #"
            ],
            "2": [
                "###",
                "  #",
                "###",
                "#  ",
                "###"
            ],
            "3": [
                "###",
                "  #",
                "###",
                "  #",
                "###"
            ],
            "4": [
                "# #",
                "# #",
                "###",
                "  #",
                "  #"
            ],
            "5": [
                "###",
                "#  ",
                "###",
                "  #",
                "###"
            ],
            "6": [
                "###",
                "#  ",
                "###",
                "# #",
                "###"
            ],
            "7": [
                "###",
                "  #",
                "  #",
                "  #",
                "  #"
            ],
            "8": [
                "###",
                "# #",
                "###",
                "# #",
                "###"
            ],
            "9": [
                "###",
                "# #",
                "###",
                "  #",
                "###"
            ]
        ]
        
        let numberStr = String(number)
        
        let digitWidth = 3
        let digitHeight = 5
        let spacing = 2 // khoảng cách giữa các chữ số
        
        let totalWidth = numberStr.count * digitWidth + (numberStr.count - 1) * spacing
        
        let offsetX = (gridSize - totalWidth) / 2
        let offsetY = (gridSize - digitHeight) / 2
        
        var coordinates: [Coordinate] = []
        var currentX = offsetX
        
        
        for ch in numberStr {
            if let pattern = digitPatterns[ch] {
                for (row, line) in pattern.enumerated() {
                    for (col, char) in line.enumerated() {
                        if char == "#" {
                            // Tọa độ của ô được "sáng" khi animation:
                            let point = Coordinate(x: currentX + col, y: offsetY + row)
                            coordinates.append(point)
                        }
                    }
                }
            }
            currentX += digitWidth + spacing
        }
        
        return coordinates
    }
}
