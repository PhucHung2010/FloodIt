//
//  ColorMode.swift
//  FlooditMultiplatform
//
//  Created by Hung Nguyen on 25/01/2025.
//

import SwiftUI


extension Color {
    static let Red = Color(red: 255 / 255, green: 58 / 255, blue: 69 / 255)
    static let Blue = Color(red: 11 / 255, green: 132 / 255, blue: 255 / 255)
    static let Green = Color(red: 50 / 255, green: 215 / 255, blue: 75 / 255)
    static let Purple = Color(red: 191 / 255, green: 40 / 255, blue: 242 / 255)
    static let Gray = Color(red: 152 / 255, green: 152 / 255, blue: 157 / 255)
    static let Cyan = Color(red: 89 / 255, green: 200 / 255, blue: 245 / 255)
    static let Brown = Color(red: 172 / 255, green: 142 / 255, blue: 104 / 255)
    static let Orange = Color(red: 255 / 255, green: 159 / 255, blue: 12 / 255)
    
    func getRGBComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        guard let cgColor = self.cgColor else { return nil }
        let components = cgColor.components
        
        if cgColor.numberOfComponents == 4 { // RGBA
            return (components![0], components![1], components![2])
        } else if cgColor.numberOfComponents == 2 { // Grayscale
            return (components![0], components![0], components![0])
        }
        
        return nil
    }
}



struct ColorMode_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
