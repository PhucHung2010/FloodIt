//
//  AnimateCubes.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 02/02/2025.
//

import Foundation
import SwiftUI

extension GameModel {
    // MARK: ANIMATE CUBE
    func animateCube(at position: (Int, Int), fillColor: Color, isVisited: Bool) {
        let (x, y) = position
        if !isVisited {
            withAnimation(
                .easeInOut(duration: 0.3)
            ) {
                board[y][x].isBombColor = false
                board[y][x].configuration.extrusion = defaultExtrusion * 4.2 / 2
                board[y][x].configuration.size = .init(
                    width: defaultLength * 2.8 / 5,
                    height: defaultLength * 2.8 / 5
                )
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(
                    .easeInOut(duration: 0.4)
                ) {
                    self.board[y][x].configuration.levitation = self.defaultLevitaion * 4 / 2
                    self.board[y][x].configuration.extrusion = self.defaultExtrusion * 0.7 / 2
                    self.board[y][x].fillColor = fillColor
                    self.board[y][x].isBombColor = false
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.293) {
                withAnimation(
                    .easeInOut(duration: 0.6)
                ) {
                    self.board[y][x].configuration.size = .init(width: self.defaultLength, height: self.defaultLength)
                    self.board[y][x].configuration.levitation = self.defaultLevitaion - 6
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.66) {
                withAnimation(
                    .easeInOut(duration: 0.56)
                ) {
                    self.board[y][x].configuration.extrusion = self.defaultExtrusion - 6
                }
            }
        }
        else {
            withAnimation(
                .easeInOut(duration: 0.4)
            ) {
                self.board[y][x].fillColor = fillColor
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.360) {}
        }
    }
    
    
    func animateDropEffectCube(at position: (Int, Int), fillColor: Color, isReversed: Bool) {
        let (x, y) = position
        if !isReversed {
            withAnimation(
                .easeInOut(duration: 0.25)
            ) {
                board[y][x].configuration.levitation = defaultLevitaion * 1.3
                board[y][x].configuration.size = .init(
                    width: defaultLength * 0.85,
                    height: defaultLength * 0.85
                )
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(
                    .easeInOut(duration: 0.5)
                ) {
                    self.board[y][x].configuration.levitation = 0
                    self.board[y][x].configuration.extrusion = self.defaultExtrusion * 0.5
                    self.board[y][x].fillColor = .clear
                    self.board[y][x].configuration.shadowColor = .clear
                    self.board[y][x].isBombColor = false
                }
            }
        } else {
            withAnimation(
                .easeInOut(duration: 0.3)
            ) {
                self.board[y][x].fillColor = fillColor
                self.board[y][x].trackingColor = fillColor
                self.board[y][x].configuration.shadowColor = .black
                self.board[y][x].configuration.shadowOpacity = board[y][x].fillColor.alpha * defaultShawdowOpacity
                
                self.board[y][x].configuration.extrusion = self.defaultExtrusion
                self.board[y][x].configuration.size = .init(
                    width: self.defaultLength,
                    height: self.defaultLength
                )
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(
                    .easeInOut(duration: 0.5)
                ) {
                    self.board[y][x].configuration.levitation = self.defaultLevitaion
                }
            }
        }
    }
    
    
    func animateFadeEffectCube(at position: (Int, Int), fillColor: Color, isReversed: Bool) {
        let (x, y) = position
        withAnimation(
            .easeInOut(duration: 0.3)
        ) {
            board[y][x].isBombColor = false
            board[y][x].configuration.extrusion = defaultExtrusion * 4.2 / 2
            board[y][x].configuration.size = .init(
                width: defaultLength * 2.8 / 5,
                height: defaultLength * 2.8 / 5
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(
                .easeInOut(duration: 0.4)
            ) {
                self.board[y][x].configuration.levitation = self.defaultLevitaion * 4 / 2
                self.board[y][x].configuration.extrusion = self.defaultExtrusion * 0.7 / 2
                self.board[y][x].fillColor = fillColor
                self.board[y][x].trackingColor = fillColor
                self.board[y][x].configuration.shadowColor = isReversed ? .black : .clear
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.293) {
            withAnimation(
                .easeInOut(duration: 0.6)
            ) {
                self.board[y][x].configuration.size = .init(width: self.defaultLength, height: self.defaultLength)
                self.board[y][x].configuration.levitation = self.defaultLevitaion
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.66) {
            withAnimation(
                .easeInOut(duration: 0.56)
            ) {
                self.board[y][x].configuration.extrusion = self.defaultExtrusion
            }
        }
    }
    
    
    func animateNumberEffectCube(at position: (Int, Int), fillColor: Color) {
        let (x, y) = position
        withAnimation(
            .easeOut(duration: 0.5)
        ) {
            board[y][x].configuration.levitation = defaultLevitaion * 2.5
            board[y][x].fillColor = fillColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(
                .interactiveSpring(response: 0.6, dampingFraction: 0.3, blendDuration: 0)
            ) {
                self.board[y][x].configuration.extrusion = self.defaultExtrusion
                self.board[y][x].configuration.levitation = self.defaultLevitaion * 0.5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(
                .interactiveSpring(response: 0.5, dampingFraction: 0.3, blendDuration: 0)
            ) {
                self.board[y][x].configuration.extrusion = self.defaultExtrusion + 4
                self.board[y][x].configuration.levitation = self.defaultLevitaion + 8
            }
        }
    }
}
