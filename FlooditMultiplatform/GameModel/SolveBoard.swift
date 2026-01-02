//
//  BestMoves.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 18/02/2025.
//

import Foundation
import SwiftUI






extension GameModel {
    func printBoard(_ board: [[Int]]) {
        for row in board {
            print(row.map { String($0) }.joined(separator: " "))
        }
        print("\n")
    }

    func isBoardUniform(_ board: [[Int]]) -> Bool {
        let firstColor = board[0][0]
        return board.allSatisfy { row in row.allSatisfy { $0 == firstColor } }
    }

    func getFloodRegion(_ board: [[Int]], startColor: Int) -> Set<[Int]> {

        var queue: [[Int]] = [[0, 0]]
        var visited: Set<[Int]> = [[0, 0]]
        let directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

        while !queue.isEmpty {
            let current = queue.removeFirst()
            for dir in directions {
                let newX = current[0] + dir[0]
                let newY = current[1] + dir[1]
                if newX >= 0, newX < gridSize, newY >= 0, newY < gridSize, !visited.contains([newX, newY]), board[newX][newY] == startColor {
                    queue.append([newX, newY])
                    visited.insert([newX, newY])
                }
            }
        }
        return visited
    }



    func floodFill(_ board: inout [[Int]], region: Set<[Int]>, newColor: Int) {
        for cell in region {
            board[cell[0]][cell[1]] = newColor
        }
    }

    func findBestColor(_ board: [[Int]], _ region: Set<[Int]>) -> Int {
        var colorCount: [Int: Int] = [:]
        let directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

        for cell in region {
            for dir in directions {
                let newX = cell[0] + dir[0]
                let newY = cell[1] + dir[1]
                if newX >= 0, newX < gridSize, newY >= 0, newY < gridSize, !region.contains([newX, newY]) {
                    let neighborColor = board[newX][newY]
                    colorCount[neighborColor, default: 0] += 3 // Tăng trọng số
                }
            }
        }

        for (color, _) in colorCount {
            var tempBoard = board
            floodFill(&tempBoard, region: region, newColor: color)
            let newRegion = getFloodRegion(tempBoard, startColor: color)
            colorCount[color]! += newRegion.count * 2 // Ưu tiên mở rộng lớn
        }

        return colorCount.max(by: { $0.value < $1.value })?.key ?? board[0][0]
    }
    
    
    
    func transformColorIntoNumber(numberBoard: inout [[Int]]) {
        numberBoard = (0..<gridSize).map { i in
            (0..<gridSize).map { j in
                return Int((currentColorBoard.firstIndex(of: PreColorBoard[i][j]) ?? 0) + 1)
            }
        }
    }
    
    func transformNumberIntoColor(moves: [Int]) {
        bestMoves = (0..<moves.count).map { i in
            return currentColorBoard[moves[i] - 1]
        }
    }
    
    
    func solveBoard(){
        var numberBoard: [[Int]] = []
        transformColorIntoNumber(numberBoard: &numberBoard)
        
        var moves: [Int] = []

        while !isBoardUniform(numberBoard) {
            let currentColor = numberBoard[0][0]
            let floodRegion = getFloodRegion(numberBoard, startColor: currentColor)
            let bestColor = findBestColor(numberBoard, floodRegion)
            floodFill(&numberBoard, region: floodRegion, newColor: bestColor)
            moves.append(bestColor)
        }
        
        transformNumberIntoColor(moves: moves)
        
        self.stepLimit = moves.count
    }
    
    func setTimeLimit() {
        var multiplier: Double = 0
        if gridSize == 8 {multiplier = 1.3}
        else if gridSize == 10 {multiplier = 2}
        else {multiplier = 3}
        timeLimit = Int(Double(stepLimit) * multiplier)
    }
}
