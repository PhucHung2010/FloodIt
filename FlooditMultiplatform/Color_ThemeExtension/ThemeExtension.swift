import Foundation
import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let darkOffWhite = Color(red: 205 / 255, green: 205 / 255, blue: 215 / 255)
    static let darkOffWhite2 = Color(red: 185 / 255, green: 185 / 255, blue: 195 / 255)
    
    static let darkStart = Color(red: 60 / 255, green: 70 / 255, blue: 75 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
    static let darkStart2 = Color(red: 70 / 255, green: 80 / 255, blue: 85 / 255)
    static let darkEnd2 = Color(red: 35 / 255, green: 35 / 255, blue: 40 / 255)
    static let darkMiddle = Color(red: 40 / 255, green: 45 / 255, blue: 50 / 255)
    static let darkMiddle2 = Color(red: 30 / 255, green: 35 / 255, blue: 40 / 255)
    
    static let darkGray05 = Color(red: 117 / 255, green: 117 / 255, blue: 117 / 255)
    static let darkGray07 = Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255)
    static let darkGray = Color(red: 90 / 255, green: 90 / 255, blue: 90 / 255)
    static let darkGray2 = Color(red: 80 / 255, green: 80 / 255, blue: 80 / 255)
    static let darkGray3 = Color(red: 60 / 255, green: 60 / 255, blue: 60 / 255)
    
    static let darkTeal = Color(red: 0 / 255, green: 56 / 255, blue: 56 / 255)
    static let lightOrange = Color(red: 255 / 255, green: 159 / 255, blue: 12 / 255)
    static let lightGray = Color(red: 190 / 255, green: 190 / 255, blue: 190 / 255)
    static let lightGrayMore =  Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255)
    
    static let lightBlue = Color(red: 200 / 255, green: 246 / 255, blue: 255 / 255)
    static let lightBlue2 = Color(red: 180 / 255, green: 226 / 255, blue: 235 / 255)
    static let darkBlueStart = Color(red: 110 / 255, green: 110 / 255, blue: 255 / 255)
    static let darkBlueEnd = Color(red: 80 / 255, green: 22 / 255, blue: 255 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
