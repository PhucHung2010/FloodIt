import SwiftUI
import CoreGraphics

struct CodableColor: Codable, Equatable {
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double

    init(color: Color) {
        // Chuyển sang CGColor để hỗ trợ cả iOS và macOS
        guard let components = color.cgColor?.components else {
            self.red = 0
            self.green = 0
            self.blue = 0
            self.opacity = 1
            return
        }

        // Với hệ màu RGB, components sẽ là [r, g, b, a]
        self.red = Double(components[safe: 0] ?? 0)
        self.green = Double(components[safe: 1] ?? 0)
        self.blue = Double(components[safe: 2] ?? 0)
        self.opacity = Double(components[safe: 3] ?? 1)
    }

    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}



extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
