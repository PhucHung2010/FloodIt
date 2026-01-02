//
//  showTimeResult.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 06/02/2025.
//

import SwiftUI

struct showTimeResult: View {
    @ObservedObject var gameLevel: GameLevel
    @State private var isVisible = false
    
    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
                .scaleEffect(isVisible ? 1 : 2)
                .rotationEffect(.degrees(isVisible ? 0 : -360))
                .background() {
                    Circle()
                        .opacity(0.9)
                        .foregroundColor(.gray)
                        .shadow(radius: 5)
                }
            
            Text("\(gameLevel.currentTime)s")
                .scaleEffect(isVisible ? 1 : 2)
                .offset(x: isVisible ? 0 : 100)
        }
        .font(.system(size: 70, weight: .heavy, design: .rounded))
        .shadow(radius: 5)
        .foregroundColor(.lightGrayMore)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 90)
                .fill(Color.black.opacity(0.3))
                .shadow(radius: 10)
        )
        .scaleEffect(isVisible ? 1 : 0.2)
        .opacity(isVisible ? 1 : 0)
        .rotationEffect(.degrees(isVisible ? 0 : -30))
        .offset(y: isVisible ? 0 : -280)
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale),
            removal: .opacity.combined(with: .scale)
        ))
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.35, blendDuration: 0)) {
                isVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.9)) {
                    isVisible = false
                }
            }
        }
        .onDisappear {
            withAnimation(.easeOut(duration: 1)) {
                isVisible = false
                gameLevel.resetTimer()
                gameLevel.currentBoardType.setTimeLimit()
            }
        }
        .frame(width: 370, height: 420)
    }
}



struct showTimeResult_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
