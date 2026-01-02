//
//  ResetGame.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 02/02/2025.
//

import Foundation
import SwiftUI

extension GameModel {
    // MARK: RESET GAME
    func resetPreColorBoard() -> Void {
        PreColorBoard = (0..<gridSize).map { _ in
            (0..<gridSize).map { _ in
                let randomColor = currentColorBoard.randomElement() ?? .lightGray
                return randomColor
            }
        }
    }
    
    func resetGame(gameMode: GameMode = .normal, animationMode: AnimationMode = .drop, beginningAnimate: Bool = true, endingAnimate: Bool = true) {
        if !self.isAnimating {
            self.showTime = false
            
            if gameMode == .normal {
                currentColorBoard = availableColors
            }
            else if gameMode == .dizzy {
                var dizzy: [Color]
                repeat {
                    dizzy = dizzyColors.randomElement() ?? dizzyColors[0]
                } while dizzy == currentColorBoard
                currentColorBoard = dizzy
            }
            
            showBestMoves = false
            resetPreColorBoard()
            visitedCells = []
            currentStep = 0
            solveBoard()
            setTimeLimit()
            gameStarted = false
            
            
            
            if animationMode == .drop {
                animateDropEffect(beginningAnimate: beginningAnimate, endingAnimate: endingAnimate, currentMode: gameMode)
            }
            else if animationMode == .fadeOut {
                animateFadeOutAndRestore(beginningAnimate: beginningAnimate, endingAnimate: endingAnimate, currentMode: gameMode)
            }
        }
    }
}
