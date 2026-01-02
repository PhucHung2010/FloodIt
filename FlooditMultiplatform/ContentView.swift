//
//  ContentView.swift
//  FLOODIT
//
//  Created by Hung Nguyen on 10/01/2025.
//

import SwiftUI


class ScreenSizeModel: ObservableObject {
    @Published var SCREEN_SIZE: CGSize = .init(width: 500, height: 500)
}




struct GameBoardView: View {
    @EnvironmentObject private var screenSizeModel: ScreenSizeModel
    
    @ObservedObject var model: GameModel
    @ObservedObject var gameLevel: GameLevel
    
    @State private var scale: CGFloat = 0.6
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var lastScale: CGFloat = 1.0
    
    @State private var slimeTest = PrismConfiguration(
                                        tilt: 0.2,
                                        size: CGSize(width: 30, height: 30),
                                        extrusion: 20,
                                        levitation: 20,
                                        shadowOpacity: 0.3
                                    )
    


    var body: some View {
        VStack (spacing: 2){
            ForEach(0..<model.gridSize, id: \.self) { row in
                HStack (spacing: 2){
                    ForEach(0..<model.gridSize, id: \.self) { col in
                        SlimePrismView(
                            currentX: col,
                            currentY: row,
                            model: model,
                            bombColor: $gameLevel.bombColor,
                            isSettingBomb: $gameLevel.isSettingBomb
                        )
                    }
                }
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay() {
            if model.showTime && gameLevel.timer {
                showTimeResult(gameLevel: gameLevel)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    let newWidth = min(max(lastOffset.width + value.translation.width, -210), 210)
                    let newHeight = min(max(lastOffset.height + value.translation.height, -235), 235)
                    
                    offset = CGSize(width: newWidth, height: newHeight)
                }
                .onEnded { _ in
                    lastOffset = offset
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    let delta = value / lastScale
                    scale = max(0.2, min(scale * delta, 2.0))
                    lastScale = value
                }
                .onEnded { _ in
                    lastScale = 1.0
                }
        )
        .frame(width: screenSizeModel.SCREEN_SIZE.width - 40, height: screenSizeModel.SCREEN_SIZE.height * 2/3.8)
        .mask(RoundedRectangle(cornerRadius: 20))
        .background() {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.darkGray)
                .shadow(color: Color.lightGray.opacity(0.6), radius: 5, x: -5, y: -5)
                .shadow(color: Color.black.opacity(0.7), radius: 7, x: 5, y: 5)
        }
        
    }
}


func areColorsEqual(_ c1: Color, _ c2: Color) -> Bool {
    let codable1 = CodableColor(color: c1)
    let codable2 = CodableColor(color: c2)
    return codable1 == codable2
}



struct ColorButtonView: View {
    @EnvironmentObject private var screenSizeModel: ScreenSizeModel
    
    @ObservedObject var model: GameModel
    @ObservedObject var gameLevel: GameLevel
    var isSettingBomb: Bool
    @State var selectedIndex: Int?
    @State var selectedChangingIndex: Int?
    
    @State private var testColorPicker = Color.Red
    @State private var showColorPicker = false

    @State private var selectedColor: Color = .blue
    @State private var dragOffset: CGFloat = 0.0
    
    @State private var isPressing = false
    
    @State private var newValueColor: Color = .clear
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 10) {
                ForEach(Array(model.currentColorBoard.enumerated()), id: \.0) { index, color in
                    VStack {
                        Button(action: {
                            if !isSettingBomb && !model.showBestMoves {
                                if gameLevel.currentMode == .custom {
                                    withAnimation(.interactiveSpring(response: 0.35, dampingFraction: 0.3)) {
                                        if selectedIndex == index {selectedIndex = nil}
                                        else {selectedIndex = index}
                                    }
                                }
                                model.selectColor(color, gameLevel: gameLevel)
                            }
                        }) {
                            Color.clear
                        }
                        .buttonStyle(CircleButtonStyle(widthNum: 75, heightNum: 75, mainColor: color, gameMode: gameLevel.currentMode, selectedIndex: selectedIndex ?? -1, index: index))
                        .overlay() {
                            if index == selectedIndex && gameLevel.currentMode == .custom && gameLevel.previousMode != .dizzy {
                                ColorPicker(selection: $newValueColor) {}
                                    .labelsHidden()
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .onChange(of: gameLevel.currentMode) {newValue in
                            if newValue != .custom {selectedIndex = nil}
                        }
                        .onChange(of: selectedIndex) { newValue in
                            if selectedIndex == index {
                                newValueColor = model.currentColorBoard[selectedIndex ?? 0]
                            }
                        }
                        .onChange(of: newValueColor) { newValue in
                            if selectedIndex == index && gameLevel.previousMode != .dizzy && newValueColor.alpha >= 0.1{
                                let otherColors = model.currentColorBoard.enumerated()
                                    .filter { $0.offset != selectedIndex }
                                    .map { $0.element }

                                if !otherColors.contains(where: { areColorsEqual($0, newValueColor) }) {
                                    model.currentColorBoard[selectedIndex ?? 0] = newValueColor
                                    model.availableColors = model.currentColorBoard
                                    model.currentColor = newValueColor
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(8)
        .background() {
            RoundedRectangle(cornerRadius: 45)
                .foregroundColor(.darkGray)
               .shadow(color: .gray, radius: 4, x: 1.1, y: 1.1)
               .shadow(color: Color.offWhite.opacity(0.5), radius: 8)
        }
        .frame(maxWidth: 400)
        .frame(width: screenSizeModel.SCREEN_SIZE.width * 9/10, height: screenSizeModel.SCREEN_SIZE.height * 1.35/5)
        .scaleEffect(screenSizeModel.SCREEN_SIZE.height < 705 ? 0.85 : 1)
//        .minimumScaleFactor(0.5)
    }
}


struct ContentView: View {
    @ObservedObject private var gameLevel = GameLevel()
    @StateObject private var screenSizeModel = ScreenSizeModel()
    @State var showInformation: Bool = false
    @AppStorage("infomation") var information: Bool = true
    @AppStorage("firstOpening") var firstOpening: Bool = true
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                Color.gray.ignoresSafeArea()
                VStack {
                    TopBar(gameLevel: gameLevel, board: gameLevel.currentBoardType, showInformation: $showInformation)

                        GameBoardView(model: gameLevel.currentBoardType, gameLevel: gameLevel)

                        ColorButtonView(model: gameLevel.currentBoardType, gameLevel: gameLevel, isSettingBomb: gameLevel.isSettingBomb)
                }
                .padding(.top)
                .padding(.bottom)
                NoteGuide(showPopup: $showInformation)
            }
            .onAppear {
                if firstOpening {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        withAnimation(.easeInOut(duration: 1)) {
                            showInformation = true
                            firstOpening = false
                        }
                    }
                }
            }
            .onAppear {
                information = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        information = false
                    }
                }
            }
            .onAppear {
                screenSizeModel.SCREEN_SIZE = geometry.size
            }
            .onChange(of: geometry.size) { newSize in
                screenSizeModel.SCREEN_SIZE = newSize
            }
        }
        .environmentObject(screenSizeModel)
        .frame(minWidth: 400, minHeight: 700)
    }
}

struct ContentView_PreviewsX: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

