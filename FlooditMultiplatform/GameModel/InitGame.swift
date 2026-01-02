//
//  InitGame.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 02/02/2025.
//

import Foundation
import SwiftUI

extension GameModel {
    // MARK: INIT DIZZY MODE
    func initDizzyColors() {
        for color in standardColors {
            var dizzy: [Color] = []
            if let colorRGB = color.getRGBComponents() {
                let R = colorRGB.red
                let G = colorRGB.green
                let B = colorRGB.blue
                for times in (0..<8) {
                    let plus = CGFloat(times) * (20.0 / 255.0)
                    let currentColor = Color(red: R - plus, green: G - plus, blue: B - plus)
                    dizzy.append(currentColor)
                }
            }
            dizzyColors.append(dizzy)
        }
    }
    
    
    // MARK: INIT GAME
    func initGame() {
        resetPreColorBoard()
        
        board = (0..<gridSize).map { i in
            (0..<gridSize).map { j in
                return DisplayedPrismConfiguration(
                    configuration: PrismConfiguration(
                        tilt: 0.2,
                        size: CGSize(width: 60, height: 60),
                        extrusion: defaultExtrusion,
                        levitation: defaultLevitaion,
                        shadowOpacity: defaultShawdowOpacity * PreColorBoard[i][j].alpha
                    ),
                    fillColor: PreColorBoard[i][j],
                    trackingColor: PreColorBoard[i][j],
                    isBombColor: false
                )
            }
        }
        visitedCells = []
        currentStep = 0
        
        if gridSize == 8 {
            DispatchQueue.global(qos: .userInitiated).async {
                self.solveBoard()
                self.setTimeLimit()
            }
        }
    }
}
