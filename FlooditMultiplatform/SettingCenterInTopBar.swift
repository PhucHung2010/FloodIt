//
//  SettingCenterInTopBar.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 02/03/2025.
//

import Foundation
import SwiftUI

extension TopBar {
    var modeSettingList: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if gameLevel.currentMode != .normal {
                        gameLevel.switchMode(to: .normal)
                        showModeSetting.toggle()
                    }
                }
            }) {
                Image(systemName: gameLevel.currentMode == .normal ? "circle.grid.2x2.fill" : "circle.grid.2x2")
                    .font(.system(size: 35))
                    .foregroundColor(.lightGrayMore)
                    .shadow(radius: 3)
                    .background() {
                        RoundedRectangle(cornerRadius: 5)
                            .opacity(0.9)
                            .foregroundColor(.gray)
                            .shadow(radius: 5)
                    }
            }
        
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if gameLevel.currentMode != .dizzy {
                        gameLevel.switchMode(to: .dizzy)
                        showModeSetting.toggle()
                    }
                }
            }) {
                Image(systemName: gameLevel.currentMode == .dizzy ? "eye.fill" : "eye")
                    .font(.system(size: 30))
                    .foregroundColor(.lightGrayMore)
                    .shadow(radius: 3)
                    .background() {
                        RoundedRectangle(cornerRadius: 5)
                            .opacity(0.9)
                            .foregroundColor(.gray)
                            .shadow(radius: 5)
                    }
            }
            
            Button(action: {
                if !board.isAnimating && gameLevel.currentCoin >= 3 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if gameLevel.currentMode == .custom {
                            if board.completedCustom() == 0 {
                                gameLevel.switchMode(to: gameLevel.previousMode)
                            } else if board.completedCustom() == 1 {
                                gameLevel.currentMode = gameLevel.previousMode
                            }
                        }
                        else {
                            gameLevel.switchMode(to: .custom)
                        }
                    }
                    gameLevel.currentCoin -= 3
                }
            }) {
                Image(systemName: gameLevel.currentMode == .custom ? "hand.tap.fill" : "hand.tap")
                    .font(.system(size: 30))
                    .foregroundColor(.lightGrayMore)
                    .shadow(radius: 3)
                    .padding(3)
                    .background() {
                        Circle()
                            .opacity(0.9)
                            .foregroundColor(.gray)
                            .shadow(radius: 5)
                    }
            }
            .buttonStyle(ScaledButtonStyle3(scaleRadius: 0.5))
        }
        .transition(.offset(x: -100).combined(with: .scale))
    }
    
    
    
    
    var levelSettingList: some View {
        HStack {
            Button(action: {
//                if gameLevel.currentBoardType.gridSize != 8 {
//                    gameLevel.currentBoardType.animateDropEffect(endingAnimate: false)
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        gameLevel.switchLevel(level: .easy)
//                    }
//                }
            }) {
                Image(systemName: gameLevel.currentBoardType.gridSize == 8 ? "8.circle.fill" : "8.circle")
                    .font(.system(size: 35))
                    .foregroundColor(.lightGrayMore)
                    .shadow(radius: 3)
                    .background() {
                        RoundedRectangle(cornerRadius: 15)
                            .opacity(0.9)
                            .foregroundColor(.gray)
                            .shadow(radius: 5)
                    }
            }
            
            Button(action: {
//                if gameLevel.currentBoardType.gridSize != 10 {
//                    gameLevel.currentBoardType.animateDropEffect(endingAnimate: false)
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        gameLevel.switchLevel(level: .medium)
//                    }
//                }
            }) {
                Image(systemName: gameLevel.currentBoardType.gridSize == 10 ? "10.circle.fill" : "10.circle")
                    .font(.system(size: 35))
                    .foregroundColor(.lightGrayMore)
                    .shadow(radius: 3)
                    .background() {
                        RoundedRectangle(cornerRadius: 15)
                            .opacity(0.9)
                            .foregroundColor(.gray)
                            .shadow(radius: 5)
                    }
            }
            
            Button(action: {
//                if gameLevel.currentBoardType.gridSize != 12 {
//                    gameLevel.currentBoardType.animateDropEffect(endingAnimate: false)
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        gameLevel.switchLevel(level: .hard)
//                    }
//                }
            }) {
                Image(systemName: gameLevel.currentBoardType.gridSize == 12 ? "12.circle.fill" : "12.circle")
                    .font(.system(size: 35))
                    .foregroundColor(.lightGrayMore)
                    .shadow(radius: 3)
                    .background() {
                        RoundedRectangle(cornerRadius: 15)
                            .opacity(0.9)
                            .foregroundColor(.gray)
                            .shadow(radius: 5)
                    }
            }
        }
        .transition(.offset(x: -100).combined(with: .scale))
    }
}
