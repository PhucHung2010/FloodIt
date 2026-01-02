//
//  WavEffect.swift
//  FLOODIT
//
//  Created by Hung Nguyen on 11/01/2025.
//

import SwiftUI




struct SlimePrismView: View {
    let currentX: Int
    let currentY: Int
    @ObservedObject var model: GameModel
    @Binding var bombColor: Int
    @Binding var isSettingBomb: Bool
    
    let defaultLength = CGFloat(60)
    let defaultExtrusion = CGFloat(40)
    let defaultLevitaion = CGFloat(40)
    let defaultTilt = CGFloat(0.2)

    @State private var isSuccessfull: Bool = false

    var body: some View {
        PrismView(configuration:  model.board[currentY][currentX].configuration) {
            model.board[currentY][currentX].fillColor
                .overlay() {
                    if model.board[currentY][currentX].isBombColor {
                        Image(systemName: "circle.hexagonpath.fill")
                            .foregroundColor(model.board[currentY][currentX].fillColor)
                            .font(.system(size: 30))
                            .brightness(-0.3)
                            .transition(.scale)
                    }
                }
                .opacity(1)
        } left: {
            model.board[currentY][currentX].fillColor.brightness(-0.1)
                .opacity(0.8)
        } right: {
            model.board[currentY][currentX].fillColor.brightness(-0.3)
                .opacity(0.8)
        }
        .onTapGesture {
            if !model.gameStarted {
                animateSlimeCube(color: model.currentColor)
            }
        }
    }
    
    
    func animateSlimeCube (color: Color?) {
        if model.board[currentY][currentX].configuration.extrusion != defaultExtrusion - 3 {
            withAnimation(.easeInOut(duration: 0.7)) {
                if isSettingBomb {
                    setBombColor(currentX: currentX, currentY: currentY, board: &model.board, bombColor: &bombColor, isSuccessfull: &isSuccessfull, isSettingBomb: &isSettingBomb)
                }
            }
            
            withAnimation(
                .easeOut(duration: 0.32)
            ) {
                // When bomb is successfully set
                if isSuccessfull {
                    model.board[currentY][currentX].configuration.extrusion = defaultExtrusion * 2
                    model.board[currentY][currentX].configuration.size = .init(
                        width: defaultLength * 1.3,
                        height: defaultLength * 1.3
                    )
                    isSuccessfull = false
                } else {
                    // When bomb is not successfully set
                    model.board[currentY][currentX].configuration.extrusion = defaultExtrusion * 0.5
                    model.board[currentY][currentX].configuration.size = .init(
                        width: defaultLength * 0.75,
                        height: defaultLength * 0.75
                    )
                    model.board[currentY][currentX].fillColor = color ?? model.board[currentY][currentX].fillColor
                    model.board[currentY][currentX].trackingColor = model.board[currentY][currentX].fillColor
                    model.PreColorBoard[currentY][currentX] = model.board[currentY][currentX].fillColor
                
                    model.board[currentY][currentX].configuration.shadowOpacity = model.board[currentY][currentX].fillColor.alpha * model.defaultShawdowOpacity
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
                withAnimation(
                    .easeIn(duration: 0.3)
                ) {
                    model.board[currentY][currentX].configuration.levitation = defaultLevitaion
                    model.board[currentY][currentX].configuration.extrusion = defaultExtrusion
                    model.board[currentY][currentX].configuration.size = .init(
                        width: defaultLength,
                        height: defaultLength
                    )
                }
            }
        }
    }
}

import SwiftUI
import CoreGraphics

extension Color {
    func toCGColor() -> CGColor? {
        #if os(iOS)
        return UIColor(self).cgColor
        #elseif os(macOS)
        return NSColor(self).cgColor
        #endif
    }

    var alpha: CGFloat {
        guard let cgColor = self.toCGColor() else { return 1.0 }
        return cgColor.alpha
    }
}


func setBombColor(currentX: Int, currentY: Int, board: inout [[DisplayedPrismConfiguration]], bombColor: inout Int, isSuccessfull: inout Bool, isSettingBomb: inout Bool) -> Void {
    if  !board[currentY][currentX].isBombColor && bombColor > 0 {
        isSuccessfull = true
        board[currentY][currentX].isBombColor = true
        bombColor -= 1
        if bombColor == 0 {
            isSettingBomb = false
        }
    }
    else {
        isSuccessfull = false
    }
}


struct PressedButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        var animation: Animation?

        /// only change when it's different
        if isPressed != configuration.isPressed {
            if configuration.isPressed {
                animation = .spring(
                    response: 0.1,
                    dampingFraction: 0.6,
                    blendDuration: 1
                )
            } else {
                animation = .spring(
                    response: 0.4,
                    dampingFraction: 0.4,
                    blendDuration: 1
                )
            }

            DispatchQueue.main.async {
                withAnimation(animation) {
                    isPressed = configuration.isPressed
                }
            }
        }

        return configuration.label
            .opacity(1) /// needs a modifier to actually be called
    }
}




struct WavEffect_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
