//
//  AnimateEffects.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 02/02/2025.
//

import Foundation
import SwiftUI

extension GameModel {
    // MARK: ANIMATE EFFECT

    func animateDropEffect(beginningAnimate: Bool = true, endingAnimate: Bool = true, timer: Bool = false, currentMode: GameMode = .normal) {
        if !isAnimating {
            self.isAnimating = true
            let totalAnimationDuration: Double = 1.5
            let delayStep = totalAnimationDuration / Double(dropEffectCoordinate.count)


            if beginningAnimate {
                for (index, layer) in dropEffectCoordinate.enumerated() {
                    let delay = Double(index) * delayStep
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        for position in layer {
                            self.animateDropEffectCube(at: (position.x, position.y), fillColor: .clear, isReversed: false)
                        }
                    }
                }
                
            }
            

            if timer {
                showTime = true
                DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration + 2) { [self] in
                    showTime = false
                }
            }


            if !endingAnimate {
                DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration + 0.2) { [self] in
                    isAnimating = false
                }
            }
            
            if endingAnimate {
                DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration + (timer ? 2 : 0.1)) { [self] in
                    let reverseLayers = self.dropEffectCoordinate.reversed()
                    for (index, layer) in reverseLayers.enumerated() {
                        let delay = Double(index) * delayStep
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            for position in layer {
                                self.animateDropEffectCube(at: (position.x, position.y), fillColor: (currentMode == .custom) ? .lightGray : self.PreColorBoard[position.y][position.x], isReversed: true)
                            }
                        }
                    }
                }

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + totalAnimationDuration * ((!beginningAnimate || !endingAnimate) ? 1 : 2) + (timer ? 2 : 0.2)
                ) {
                    self.isAnimating = false
                }
            }
        }
    }

    
    
    func animateFadeOutAndRestore(beginningAnimate: Bool = true, endingAnimate: Bool = true, timer: Bool = false, currentMode: GameMode) {
        if !isAnimating {
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                self.isAnimating = true
                let totalAnimationDuration: Double = 5.0 * (Double(gridSize) / 8.0)
                let delayStep = totalAnimationDuration / Double(fadingEffectCoordinate.count)

                if beginningAnimate {
                    for (index, position) in self.fadingEffectCoordinate.enumerated() {
                        let delay = Double(index) * delayStep
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            self.animateFadeEffectCube(at: (position.x, position.y), fillColor: .clear, isReversed: false)
                        }
                    }
                }


                if timer {
                    DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration + 0.3) { [self] in
                        showTime = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                            showTime = false
                        }
                    }
                }
                
                
                if endingAnimate {
                    DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration + ((timer ? 3 : 0.3))) { [self] in
                        let reverseEffect = self.fadingEffectCoordinate.reversed()
                        for (index, position) in reverseEffect.enumerated() {
                            let delay = Double(index) * delayStep
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                self.animateFadeEffectCube(at: (position.x, position.y), fillColor: (currentMode == .custom) ? .lightGray : self.PreColorBoard[position.y][position.x], isReversed: true)
                            }
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration * (Double(gridSize) / 8.0) * 2 + 0.5) {
                        self.isAnimating = false
                    }
                }
            }
        }
    }

    
    
    func animateNumberAnimation(number: Int, fillColor: Color = .clear) {
        let numberCoordinates = initNumberAnimation(for: number)
        
        if fillColor == .clear {
            let delayStep: Double = 0.01

            DispatchQueue.global(qos: .userInitiated).async { [self] in
                for (index, position) in numberCoordinates.enumerated() {
                    let delay = Double(index) * delayStep
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.animateNumberEffectCube(at: (position.x, position.y), fillColor: .clear)
                    }
                }
            }
        }
        else if let rgb = fillColor.getRGBComponents() {
            let fillNumberColor = Color(red: rgb.red - CGFloat(70) / 255,
                              green: rgb.green - CGFloat(70) / 255,
                              blue: rgb.blue - CGFloat(70) / 255)

            let delayStep: Double = 0.01

            DispatchQueue.global(qos: .userInitiated).async { [self] in
                for (index, position) in numberCoordinates.enumerated() {
                    let delay = Double(index) * delayStep
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.animateNumberEffectCube(at: (position.x, position.y), fillColor: fillNumberColor)
                    }
                }
            }
        }
    }

    
    
    func animateFloodFill(from start: (x: Int, y: Int)) {
        if !isAnimating {
            let targetColor = board[start.y][start.x].trackingColor
            var visited = Set<Coordinate>()
            var positionsToAnimate: [(Coordinate, TimeInterval, Bool)] = []

            
            var queue: [(Coordinate, TimeInterval)] = [(Coordinate(x: start.x, y: start.y), 0)]
            while !queue.isEmpty {
                let (current, delay) = queue.removeFirst()
                let x = current.x, y = current.y

                guard x >= 0, y >= 0, x < gridSize, y < gridSize else { continue }
                guard board[y][x].trackingColor == targetColor else { continue }
                guard !visited.contains(current) else { continue }

                visited.insert(current)

                
                if !visitedCells.contains(current) {
                    if board[y][x].isBombColor {
                        for (dx, dy) in bombDirections {
                            let newX = x + dx
                            let newY = y + dy

                            if newX >= 0, newX < gridSize, newY >= 0, newY < gridSize {
                                board[newY][newX].trackingColor = targetColor
                                positionsToAnimate.append((Coordinate(x: newX, y: newY), delay, false))
                            }
                        }
                    }
                    positionsToAnimate.append((current, delay, false))
                }
                else {
                    positionsToAnimate.append((current, delay, true))
                }
                
                let newDelay = delay + 0.065
                queue.append((Coordinate(x: x + 1, y: y), newDelay))
                queue.append((Coordinate(x: x - 1, y: y), newDelay))
                queue.append((Coordinate(x: x, y: y + 1), newDelay))
                queue.append((Coordinate(x: x, y: y - 1), newDelay))
            }

            
            visitedCells.formUnion(visited)

            
            DispatchQueue.global(qos: .userInitiated).async {
                for (position, delay, isVisited) in positionsToAnimate {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.animateCube(at: (position.x, position.y), fillColor: targetColor, isVisited: isVisited)
                    }
                }
            }
        }
    }
}


struct AnimateEffects_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
