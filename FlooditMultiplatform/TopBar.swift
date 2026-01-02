//
//  TopBar.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 16/01/2025.
//

import SwiftUI

struct TopBar: View {
    @ObservedObject var gameLevel: GameLevel
    @ObservedObject var board: GameModel
    
    @State var showModeSetting: Bool = false
    @State var showLevelSetting: Bool = false
    @State var showMoney: Bool = false
    @Binding var showInformation: Bool
    
    @AppStorage("infomation") var information: Bool = true
    
    
    var body: some View {
        VStack (spacing: 20){
            HStack {
                if board.gameStarted {
                    Text("\(board.currentStep) | \(board.stepLimit)")
                        .font(.system(size: 35, weight: .heavy, design: .rounded))
                        .shadow(radius: 3)
                        .foregroundColor(.lightGrayMore)
                        .padding(.horizontal)
                        .background() {
                            RoundedRectangle(cornerRadius: 30)
                                .opacity(0.9)
                                .foregroundColor(.darkGray)
                                .frame(height: 50)
                                .shadow(color: Color.lightGray.opacity(0.6), radius: 5, x: -5, y: -5)
                                .shadow(color: Color.black.opacity(0.7), radius: 7, x: 2, y: 5)
                        }
                        .transition(.scale.combined(with: .opacity))
                }
            

                
                // MARK: Reset Button
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if gameLevel.timerPlaying {
                                gameLevel.resetTimer()
                            }
                            board.resetGame(gameMode: gameLevel.currentMode)
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise.circle")
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
                    
                    if (board.showBestMoves && board.gameStarted) || (!board.gameStarted) {
                        Button(action: {
                            if !board.showBestMoves && gameLevel.currentCoin >= 3 && !(gameLevel.currentMode == .custom) {
                                board.showSolution(gameLevel: gameLevel)
                                gameLevel.currentCoin -= 3
                            }
                        }) {
                            Image(systemName: board.showBestMoves ? "key.fill" : "key")
                                .font(.system(size: 30))
                                .foregroundColor(.lightGrayMore)
                                .shadow(radius: 3)
                                .background() {
                                    RoundedRectangle(cornerRadius: 12)
                                        .opacity(0.9)
                                        .foregroundColor(.gray)
                                        .shadow(radius: 5)
                                }
                        }
                    }
                    
                    if !board.gameStarted {
                        // MARK: Mode setting button
                        Button(action: {
                            switch showModeSetting {
                            case false:
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showModeSetting = true
                                    showLevelSetting = false
                                }
                            case true:
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showModeSetting = false
                                    showLevelSetting = false
                                }
                            }
                        }) {
                            Image(systemName: showModeSetting ? "gearshape.circle.fill" : "gearshape.circle")
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
                        .transition(.scale.combined(with: .opacity))

                        // MARK: Mode setting list
                        if showModeSetting {modeSettingList}

                        
                        // MARK: Level setting button
                        Button(action: {
                            switch showLevelSetting {
                            case false:
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showLevelSetting = true
                                    showModeSetting = false
                                }
                            case true:
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showLevelSetting = false
                                    showModeSetting = false
                                }
                            }
                        }) {
                            Image(systemName: showLevelSetting ? "list.bullet.circle.fill" : "list.bullet.circle")
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
                        .transition(.scale.combined(with: .opacity))
                        
                        // MARK: Level setting list
                        if showLevelSetting {levelSettingList}
                    }
                }
                .padding(.horizontal, 5)
                .buttonStyle(ScaledButtonStyle3(scaleRadius: 0.5))
                .background() {
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(.darkGray)
                        .frame(height: 50)
                        .shadow(color: Color.lightGray.opacity(0.6), radius: 5, x: -5, y: -5)
                        .shadow(color: Color.black.opacity(0.7), radius: 7, x: 2, y: 5)
                }
                
                
                
            }
            
            
            
        
            HStack {
                if !board.gameStarted {
                    HStack {
                        // MARK: Dolar sign
                        ZStack {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showMoney.toggle()
                                }
                            }) {
                                Image(systemName: showMoney ? "dollarsign.circle.fill" : "dollarsign.circle")
                                    .font(.system(size: 33))
                                    .foregroundColor(.lightGrayMore)
                                    .shadow(radius: 3)
                                    .padding(2)
                                    .background() {
                                        Circle()
                                            .opacity(0.9)
                                            .foregroundColor(.gray)
                                            .shadow(radius: 5)
                                    }
                            }
                            .buttonStyle(ScaledButtonStyle3(scaleRadius: 0.5))
                        }
                        
                        if showMoney {
                            Text("\(gameLevel.currentCoin) ")
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .shadow(radius: 3)
                                .foregroundColor(.lightGrayMore)
                                .transition(.scale.combined(with: .offset(x: -50)))
                        }
                    }
                    .padding(1)
                    .background() {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.darkGray)
                            .frame(height: 47)
                            .shadow(color: Color.lightGray.opacity(0.6), radius: 5, x: -5, y: -5)
                            .shadow(color: Color.black.opacity(0.7), radius: 7, x: 2, y: 5)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                // MARK: Bomb
                if !board.gameStarted {
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                gameLevel.isSettingBomb.toggle()
                            }
                        }) {
                            Image(systemName: gameLevel.isSettingBomb ? "circle.hexagonpath.fill" : "circle.hexagonpath")
                                .font(.system(size: 33))
                                .foregroundColor(.lightGrayMore)
                                .shadow(radius: 3)
                                .padding(2)
                                .background() {
                                    Circle()
                                        .opacity(0.9)
                                        .foregroundColor(.gray)
                                        .shadow(radius: 5)
                                }
                        }
                        .buttonStyle(ScaledButtonStyle3(scaleRadius: 0.5))
                        
                        if gameLevel.isSettingBomb {
                            bombBuying
                                .transition(.scale.combined(with: .offset(x: -80)))
                        }
                    }
                    .padding(1)
                    .background() {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.darkGray)
                            .frame(height: 47)
                            .shadow(color: Color.lightGray.opacity(0.6), radius: 5, x: -5, y: -5)
                            .shadow(color: Color.black.opacity(0.7), radius: 7, x: 2, y: 5)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                // MARK: CLOCK
                if !board.gameStarted || gameLevel.timer {
                    HStack {
                        Button(action: {
                            if !board.gameStarted {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    gameLevel.timer.toggle()
                                }
                            }
                        }) {
                            HStack {
                                if board.gameStarted {
                                    Image((gameLevel.currentTime > board.timeLimit) ? "clock_cropped_image_red" : "clock_cropped_image")
                                } else {
                                    Image(gameLevel.timer ? "clock_cropped_image" : "clock_cropped_image_offColor")
                                }
                            }
                            .rotationEffect(.degrees(Double(Double(gameLevel.currentTime) / Double(board.timeLimit)) * 360))
                            .foregroundColor(.lightGrayMore)
                            .shadow(radius: 3)
                            .background() {
                                Circle()
                                    .opacity(0.9)
                                    .foregroundColor(.gray)
                                    .shadow(radius: 5)
                            }
                        }
                        .animation(.interactiveSpring(response: 0.2, dampingFraction: 0.4), value: gameLevel.currentTime)
                        
                        if gameLevel.timer && board.gameStarted {
                            Text("\(gameLevel.currentTime) | \(board.timeLimit) ")
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .shadow(radius: 3)
                                .foregroundColor(.lightGrayMore)
                                .transition(.scale.combined(with: .offset(x: -50)))
                        }
                    }
                    .padding(3)
                    .background() {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.darkGray)
                            .frame(height: 48)
                            .shadow(color: Color.lightGray.opacity(0.6), radius: 5, x: -5, y: -5)
                            .shadow(color: Color.black.opacity(0.7), radius: 7, x: 2, y: 5)
                    }
                    .buttonStyle(ScaledButtonStyle3(scaleRadius: 0.5))
                    .transition(.scale.combined(with: .opacity))
                }
                
                //MARK: INFO
                if !board.gameStarted && information {
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showInformation = true
                            }
                        }) {
                            Image(systemName: showInformation ? "info.circle.fill" : "info.circle")
                                .font(.system(size: 33))
                                .foregroundColor(.lightGrayMore)
                                .shadow(radius: 3)
                                .padding(2)
                                .background() {
                                    Circle()
                                        .opacity(0.9)
                                        .foregroundColor(.gray)
                                        .shadow(radius: 5)
                                }
                        }
                        .buttonStyle(ScaledButtonStyle3(scaleRadius: 0.5))
                    }
                    .padding(1)
                    .background() {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.darkGray)
                            .frame(height: 47)
                            .shadow(color: Color.lightGray.opacity(0.6), radius: 5, x: -5, y: -5)
                            .shadow(color: Color.black.opacity(0.7), radius: 7, x: 2, y: 5)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            
        }
        .onChange(of: board.gameStarted) {_ in
            if board.gameStarted {
                showModeSetting = false
                showLevelSetting = false
            }
        }
        .animation(.easeInOut(duration: 0.5), value: board.gameStarted)
    }
    
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension TopBar {
    var bombBuying: some View {
        HStack {
            Text("\(gameLevel.bombColor) ")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .shadow(radius: 3)
                .foregroundColor(.lightGrayMore)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if gameLevel.currentCoin >= 2 {
                        gameLevel.bombColor += 1
                        gameLevel.currentCoin -= 2
                    }
                }
            }) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 36))
                    .foregroundColor(.lightGrayMore)
                    .shadow(radius: 3)
                    .background() {
                        Circle()
                            .opacity(0.9)
                            .foregroundColor(.gray)
                            .shadow(radius: 5)
                    }
            }
            .padding(1)
            .buttonStyle(ScaledButtonStyle3(scaleRadius: 0.8, animationDuration: 0.2))
        }
    }
}
