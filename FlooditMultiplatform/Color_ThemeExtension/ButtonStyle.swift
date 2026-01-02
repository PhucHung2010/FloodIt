//
//  ButtonStyle.swift
//  CALCULATOR
//
//  Created by Hung Nguyen on 15/08/2024.
//

import SwiftUI




struct CircleButtonStyle: ButtonStyle {
    var widthNum: CGFloat
    var heightNum: CGFloat
    var cornerRadius: CGFloat

    var symbolScaleEffect: CGFloat
    var backgroundScaleEffect: CGFloat
    var mainColor: Color
    var gameMode: GameMode
    var selectedIndex: Int
    var index: Int

    init(widthNum: CGFloat = 80, heightNum: CGFloat = 80, cornerRadius: CGFloat = 15, symbolScaleEffect: CGFloat = 2, backgroundScaleEffect: CGFloat = 1.4, mainColor: Color, gameMode: GameMode, selectedIndex: Int, index: Int) {
        self.widthNum = widthNum
        self.heightNum = heightNum
        self.cornerRadius = cornerRadius
        self.symbolScaleEffect = symbolScaleEffect
        self.backgroundScaleEffect = backgroundScaleEffect
        self.mainColor = mainColor
        self.gameMode = gameMode
        self.selectedIndex = selectedIndex
        self.index = index
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background {
                if configuration.isPressed {
                    Circle()
                        .fill(mainColor)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
                        .frame(width: widthNum, height: heightNum)
                } else {
                    Circle()
                        .fill(mainColor)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .blur(radius: 4)
                                .offset(x: -1, y: -1)
                                .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 3)
                                .blur(radius: 4)
                                .offset(x: 1, y: 1)
                                .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                        )
                        .background() {
                            Circle()
                                .stroke(Color.black.opacity(0.3), lineWidth: 2)
                                .blur(radius: 6)
                        }
                        .frame(width: widthNum, height: heightNum)
                }
            }
            .shadow(radius: 3)
            .scaleEffect(configuration.isPressed || (gameMode == .custom && index == selectedIndex) ? 0.8 : 1)
            .animation(.interactiveSpring(response: 0.45, dampingFraction: 0.7), value: configuration.isPressed)
            .frame(width: widthNum, height: heightNum)
    }
}


struct ContentView_PreviewsButtonStyle: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ScaledButtonStyle3: ButtonStyle {
    var scaleRadius: CGFloat
    var animationDuration: CGFloat
    init(scaleRadius: CGFloat = 3.5, animationDuration: CGFloat = 0.3) {
        self.scaleRadius = scaleRadius
        self.animationDuration = animationDuration
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.2 : 1)
            .scaleEffect(configuration.isPressed ? scaleRadius : 1)
            .animation(.easeInOut(duration: animationDuration), value: configuration.isPressed)
    }
}





struct ScaledButtonStyle: ButtonStyle {
    var scaleRadius: CGFloat
    init(scaleRadius: CGFloat = 3.5) {
        self.scaleRadius = scaleRadius
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleRadius : 1)
            .animation(.easeInOut(duration: 0.5), value: configuration.isPressed)
    }
}


struct ScaledButtonStyle2: ButtonStyle {
    var scaleRadius: CGFloat
    init(scaleRadius: CGFloat = 3.5) {
        self.scaleRadius = scaleRadius
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleRadius : 1)
            .animation(.interactiveSpring(response: 1.2, dampingFraction: 0.2), value: configuration.isPressed)
            
    }
}



//    func animateFloodFill(from start: (x: Int, y: Int)) {
//        let targetColor = board[start.y][start.x].trackingColor
//        var visited = Set<Coordinate>()
//        var positionsToAnimate: [(Coordinate, TimeInterval)] = []
//
//        // BFS to collect positions to animate
//        var queue: [(Coordinate, TimeInterval)] = [(Coordinate(x: start.x, y: start.y), 0)]
//        while !queue.isEmpty {
//            let (current, delay) = queue.removeFirst()
//            let x = current.x, y = current.y
//
//            guard x >= 0, y >= 0, x < gridSize, y < gridSize else { continue }
//            guard board[y][x].trackingColor == targetColor else { continue }
//            guard !visited.contains(current) else { continue }
//
//            visited.insert(current)
//            positionsToAnimate.append((current, delay))
//
//            let newDelay = delay + 0.085
//            queue.append((Coordinate(x: x + 1, y: y), newDelay))
//            queue.append((Coordinate(x: x - 1, y: y), newDelay))
//            queue.append((Coordinate(x: x, y: y + 1), newDelay))
//            queue.append((Coordinate(x: x, y: y - 1), newDelay))
//        }
//
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            for (position, delay) in positionsToAnimate {
//                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                    self.animateCube(at: (position.x, position.y), fillColor: targetColor, isVisited: false)
//                }
//            }
//        }
//    }


//struct TinyFuncButtonStyle: ButtonStyle {
//
//    var widthNum: CGFloat
//    var heightNum: CGFloat
//    var cornerRadius: CGFloat
//
//    var symbolScaleEffect: CGFloat
//    var backgroundScaleEffect: CGFloat
//    var THEME: ThemeStyle
//    var moreButton: Bool
//
//    init(widthNum: CGFloat = 95, heightNum: CGFloat = 75, cornerRadius: CGFloat = 20, symbolScaleEffect: CGFloat = 2, backgroundScaleEffect: CGFloat = 1.4, THEME: ThemeStyle = StyleChoices().lightTheme, moreButton: Bool = false) {
//        self.widthNum = widthNum
//        self.heightNum = heightNum
//        self.cornerRadius = cornerRadius
//        self.symbolScaleEffect = symbolScaleEffect
//        self.backgroundScaleEffect = backgroundScaleEffect
//        self.THEME = THEME
//        self.moreButton = moreButton
//    }
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .scaleEffect(configuration.isPressed ? symbolScaleEffect : 1)
//            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//            .background{
//                RoundedRectangle(cornerRadius: moreButton ? 40 : cornerRadius)
//                    .foregroundColor(moreButton ? THEME.MoreFuncButton_background : THEME.TinyFuncButton_background)
//                    .scaleEffect(0.6)
//                    .frame(width: moreButton ? widthNum + 5 : widthNum, height: heightNum)
//                    .shadow(color: moreButton ? THEME.MoreFuncButton_shadow.opacity(0.5) : THEME.TinyFuncButton_shadow.opacity(0.5), radius: 1.5, x: 0, y: 0)
//            }
//            .scaleEffect(configuration.isPressed ? backgroundScaleEffect : 1)
//            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
//    }
//}


//struct NumberButtonStyle: ButtonStyle {
//
//    var widthNum: CGFloat
//    var heightNum: CGFloat
//    var cornerRadius: CGFloat
//    var lineWidth: CGFloat
//    var THEME: ThemeStyle
//
//    init(widthNum: CGFloat = 140, heightNum: CGFloat = 100, cornerRadius: CGFloat = 30, lineWidth: CGFloat = 2, THEME: ThemeStyle = StyleChoices().lightTheme) {
//        self.widthNum = widthNum
//        self.heightNum = heightNum
//        self.cornerRadius = cornerRadius
//        self.lineWidth = lineWidth
//        self.THEME = THEME
//    }
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        if THEME.backgroundStart == .offWhite {
//            configuration.label
//            .scaleEffect(configuration.isPressed ? 0.3 : 1)
//            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
//            .overlay(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .stroke(lineWidth: lineWidth)
//                   .foregroundColor(.offWhite)
//                   .shadow(color: .gray, radius: 3, x: 1.1, y: 1.1)
//                   .scaleEffect(0.6)
//                   .frame(width: widthNum, height: heightNum)
//            )
//            .background(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .foregroundColor(Color.offWhite)
//                    .scaleEffect(0.6)
//                    .frame(width: widthNum, height: heightNum)
//                    .shadow(color: .gray, radius: 2, x: 1, y: 1)
//            )
//            .scaleEffect(configuration.isPressed ? 0.8 : 1)
//            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//            .shadow(color: .gray, radius: 1.5, x: 1.1, y: 1.1)
//            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//        }
//        else if THEME.backgroundStart == .darkStart {
//
//            configuration.label
//            .scaleEffect(configuration.isPressed ? 0.3 : 1)
//            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
//            .overlay(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .stroke(lineWidth: lineWidth + 0.5)
//                    .foregroundColor(.darkStart.opacity(0.8))
//                   .shadow(color: .darkEnd, radius: 4, x: 2, y: 2)
//                   .shadow(color: .darkEnd, radius: 4, x: -2, y: -2)
//                   .scaleEffect(0.6)
//                   .frame(width: widthNum, height: heightNum)
//            )
//            .background(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .foregroundColor(Color.darkStart)
//                    .scaleEffect(0.6)
//                    .frame(width: widthNum, height: heightNum)
//            )
//            .scaleEffect(configuration.isPressed ? 0.8 : 1)
//            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//        }
//        else {
//
//            configuration.label
//            .scaleEffect(configuration.isPressed ? 0.3 : 1)
//            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
//            .background(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .foregroundColor(Color.gray)
//                    .shadow(color: .darkGray, radius: 1.5, x: 0, y: 0)
//                    .shadow(color: .darkGray, radius: 1.5, x: -0, y: -0)
//                    .scaleEffect(0.6)
//                    .frame(width: widthNum, height: heightNum)
//            )
//            .shadow(radius: configuration.isPressed ? 1 : 2)
//            .scaleEffect(configuration.isPressed ? 0.8 : 1)
//            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//        }
//    }
//}
//
//struct Circle_FunctionButtonStyle: ButtonStyle {
//
//
//        }
//        else if THEME.backgroundStart == .darkStart{
//            configuration.label
//                .padding(30)
//                .scaleEffect(configuration.isPressed ? 0.9 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//                .background {
//                    if configuration.isPressed {
//                        Circle()
//                            .fill(LinearGradient(Color.darkEnd, Color.darkStart))
//                            .frame(width: widthNum, height: heightNum)
//                            .shadow(color: Color.darkStart, radius: 5, x: 2, y: 2)
//                            .shadow(color: Color.darkEnd, radius: 5, x: -2, y: -2)
//                    } else {
//                        Circle()
//                            .fill(LinearGradient(Color.darkStart, Color.darkEnd))
//                            .frame(width: widthNum, height: heightNum)
//                            .shadow(color: Color.darkStart, radius: 5, x: -2, y: -2)
//                            .shadow(color: Color.darkEnd, radius: 5, x: 2, y: 2)
//                    }
//                }
//                .scaleEffect(configuration.isPressed ? 0.8 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//        }
//        else {
//            configuration.label
//                .padding(30)
//                .scaleEffect(configuration.isPressed ? 0.9 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//                .background {
//                    if configuration.isPressed {
//                        Circle()
//                            .fill(LinearGradient(Color.darkOffWhite2, Color.darkGray))
//                            .frame(width: widthNum, height: heightNum)
//                    } else {
//                        Circle()
//                            .fill(LinearGradient(Color.darkOffWhite2, Color.darkGray))
//                            .frame(width: widthNum, height: heightNum)
//                    }
//                }
//                .shadow(radius: configuration.isPressed ? 1 : 3)
//                .scaleEffect(configuration.isPressed ? 0.8 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//        }
//
//    }
//}
//
//
//
//struct FunctionButtonStyle: ButtonStyle {
//    var widthNum: CGFloat
//    var heightNum: CGFloat
//    var cornerRadius: CGFloat
//    var THEME: ThemeStyle
//
//    init(widthNum: CGFloat = 80, heightNum: CGFloat = 70, cornerRadius: CGFloat = 25, THEME: ThemeStyle = StyleChoices().lightTheme) {
//        self.widthNum = widthNum
//        self.heightNum = heightNum
//        self.cornerRadius = cornerRadius
//        self.THEME = THEME
//    }
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        if THEME.backgroundStart == .offWhite {
//            configuration.label
//                .scaleEffect(configuration.isPressed ? 1.8 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//                .padding(30)
//                .background(
//                    Group {
//                        if configuration.isPressed {
//                            RoundedRectangle(cornerRadius: cornerRadius)
//                                .fill(Color.offWhite)
//                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
//                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//                                .frame(width: widthNum, height: heightNum)
//                        } else {
//                            RoundedRectangle(cornerRadius: cornerRadius)
//                                .fill(Color.offWhite)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: cornerRadius)
//                                        .stroke(Color.gray, lineWidth: 4)
//                                        .blur(radius: 4)
//                                        .offset(x: 2, y: 2)
//                                        .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(Color.black, Color.clear)))
//                                        .frame(width: widthNum, height: heightNum)
//                                )
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: cornerRadius)
//                                        .stroke(Color.white, lineWidth: 8)
//                                        .blur(radius: 4)
//                                        .offset(x: -2, y: -2)
//                                        .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(Color.clear, Color.black)))
//                                        .frame(width: widthNum, height: heightNum)
//                                )
//                        }
//                    }
//                )
//                .scaleEffect(configuration.isPressed ? 0.8 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//        }
//        else if THEME.backgroundStart == .darkStart{
//            configuration.label
//                .padding(30)
//                .scaleEffect(configuration.isPressed ? 1.8 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//                .background {
//                    if configuration.isPressed {
//                        RoundedRectangle(cornerRadius: cornerRadius)
//                            .fill(LinearGradient(Color.darkEnd, Color.darkStart))
//                            .frame(width: widthNum, height: heightNum - 5)
//                            .shadow(color: Color.darkStart, radius: 5, x: 1, y: 1)
//                            .shadow(color: Color.darkEnd, radius: 5, x: -1, y: -1)
//                    } else {
//                        RoundedRectangle(cornerRadius: cornerRadius)
//                            .fill(LinearGradient(Color.darkStart, Color.darkEnd))
//                            .frame(width: widthNum, height: heightNum - 5)
//                            .shadow(color: Color.darkStart, radius: 5, x: -1, y: -1)
//                            .shadow(color: Color.darkEnd, radius: 5, x: 1, y: 1)
//                    }
//                }
//                .scaleEffect(configuration.isPressed ? 0.8 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//        }
//        else {
//            configuration.label
//                .scaleEffect(configuration.isPressed ? 1.8 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//                .padding(30)
//                .background(
//                    Group {
//                        if configuration.isPressed {
//                            RoundedRectangle(cornerRadius: cornerRadius)
//                                .fill(Color.darkBlueStart)
//                                .frame(width: widthNum, height: heightNum)
//                        } else {
//                            RoundedRectangle(cornerRadius: cornerRadius)
//                                .fill(Color.darkBlueStart)
//                                .frame(width: widthNum, height: heightNum)
//                        }
//                    }
//                )
//                .shadow(radius: configuration.isPressed ? 1 : 2)
//                .scaleEffect(configuration.isPressed ? 0.8 : 1)
//                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//        }
//
//    }
//}
//
//
//struct extraOperatorButtonStyle: ButtonStyle {
//    var widthNum: CGFloat
//    var heightNum: CGFloat
//    var cornerRadius: CGFloat
//
//    var symbolScaleEffect: CGFloat
//    var backgroundScaleEffect: CGFloat
//
//
//    var scale: CGFloat
//    var opacity: CGFloat
//    var rotationEffect: Angle
//
//    var THEME: ThemeStyle
//
//    init(widthNum: CGFloat = 300, heightNum: CGFloat = 100, cornerRadius: CGFloat = 20, symbolScaleEffect: CGFloat = 1.2, backgroundScaleEffect: CGFloat = 1.25, _ scale: CGFloat, _ opacity: CGFloat, _ rotationEffect: Angle, THEME: ThemeStyle) {
//        self.widthNum = widthNum
//        self.heightNum = heightNum
//        self.cornerRadius = cornerRadius
//        self.symbolScaleEffect = symbolScaleEffect
//        self.backgroundScaleEffect = backgroundScaleEffect
//        self.scale = scale
//        self.opacity = opacity
//        self.rotationEffect = rotationEffect
//        self.THEME = THEME
//    }
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .scaleEffect(configuration.isPressed ? symbolScaleEffect : 1)
//            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//            .background{
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .foregroundColor(THEME.TinyFuncButton_background)
//                    .scaleEffect(0.6)
//                    .frame(width: widthNum, height: heightNum)
//                    .shadow(color: THEME.TinyFuncButton_shadow.opacity(0.5), radius: 1.5, x: 0, y: 0)
//            }
//            .scaleEffect(configuration.isPressed ? backgroundScaleEffect : 1)
//            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
//            .scaleEffect(scale)
//            .opacity(opacity)
//            .rotation3DEffect(
//                rotationEffect,
//                axis: (x: 1, y: 0, z: 0)
//            )
//
//            .animation(.easeInOut(duration: 0.8), value: rotationEffect)
//            .animation(.easeInOut(duration: 0.8), value: scale)
//            .animation(.easeInOut(duration: 0.8), value: opacity)
//    }
//}
//
//
//
//
//
//
//
//
//struct Home_2: View {
//    var body: some View {
//        ZStack {
//            LinearGradient(.darkOffWhite2, .gray).ignoresSafeArea()
//
//            VStack (spacing: 70){
//
//                Button(action: {
//                    print("Button tapped")
//                }) {
//                    Number("6", numberColor: .darkOffWhite)
//                }
//                .buttonStyle(NumberButtonStyle(THEME: StyleChoices().defaultTheme))
//
//                Button(action: {
//                    print("Button tapped")
//                }) {
//                    Number("sin", numberColor: .darkOffWhite, fontSize: 25)
//                }
//                .buttonStyle(TinyFuncButtonStyle(THEME: StyleChoices().defaultTheme))
//
//                Button(action: {
//                    print("Button tapped")
//                }) {
//                    Symbol("minus", symbolColor: .white)
//                }
//                .buttonStyle(Circle_FunctionButtonStyle(THEME: StyleChoices().defaultTheme))
//
//                Button(action: {
//                    print("Button tapped")
//                }) {
//                    Symbol("trash", symbolColor: .offWhite, symbolSize: 40)
//                }
//                .buttonStyle(FunctionButtonStyle(THEME: StyleChoices().defaultTheme))
//            }
//
//        }
//
//    }
//}
//
//struct Preview: PreviewProvider {
//    static var previews: some View {
//        Home_2()
//    }
//}
//
