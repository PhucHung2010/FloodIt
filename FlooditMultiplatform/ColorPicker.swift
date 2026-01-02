import SwiftUI

struct CustomColorPicker: View {
    @EnvironmentObject private var screenSizeModel: ScreenSizeModel
    
    @Binding var selectedColor: Color
    @Binding var dragOffset: CGFloat
    
    #if os(iOS)
    @Binding var uiColor: UIColor
    #else
    @Binding var nsColor: NSColor
    #endif

    @State private var isDragging = false
    
    
    
    // Dải màu phổ cơ bản
    let gradientColors: [Color] = [.black, .white, .red, .orange, .yellow, .green, .blue, .purple]

    var body: some View {
        VStack {
            ZStack {
                // Phổ màu nền
                RoundedRectangle(cornerRadius: 30)
                    .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 25)
                    .shadow(radius: 8)

                // Nút kéo

                Circle()
                    .fill(Color.white)
                    .frame(width: 35, height: 35)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 0)
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                updateColor(at: value.location.x, screenWidth: screenSizeModel.SCREEN_SIZE.width)
                                print(dragOffset)
                            }
                            .onEnded { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isDragging = false
                                }
                            }
                    )
                    .animation(.easeInOut(duration: 0.15), value: dragOffset)


                    selectedColor
                        .frame(width: 80, height: 20)
                        .cornerRadius(30)
                        .shadow(radius: 4)
                        .foregroundColor(.white)
                        .offset(x: dragOffset, y: -50)
                        .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.1), value: dragOffset)

            }
        }
        .frame(width: 300)
        .animation(.easeInOut(duration: 0.3), value: isDragging)
        .padding(.horizontal, 20)
    }
    

    // Cập nhật màu sắc dựa trên vị trí kéo
//    func updateColor(at position: CGFloat, screenWidth: CGFloat) {
//        let width = screenWidth // Giới hạn phạm vi kéo
////        let relativePosition = min(max(position, 0), width) / width
////        let colorPosition = CGFloat(gradientColors.count - 1) * relativePosition
//        let relativePosition = width
//        let colorPosition = CGFloat(gradientColors.count - 1)
//        let startIndex = Int(floor(colorPosition))
//        let endIndex = Int(ceil(colorPosition))
//
//        #if os(iOS)
//        let startColor = UIColor(gradientColors[startIndex])
//        let endColor = UIColor(gradientColors[endIndex])
//        let color = UIColor.interpolate(from: startColor, to: endColor, fraction: colorPosition - CGFloat(startIndex))
//        uiColor = color
//        selectedColor = Color(color)
//        #else
//        let startColor = NSColor(gradientColors[startIndex])
//        let endColor = NSColor(gradientColors[endIndex])
//        let color = NSColor.interpolate(from: startColor, to: endColor, fraction: colorPosition - CGFloat(startIndex))
//        nsColor = color
//        selectedColor = Color(color)
//        #endif
//
//        // Giới hạn vị trí kéo
//        dragOffset = position
//    }
    func updateColor(at position: CGFloat, screenWidth: CGFloat) {
        let colorCount = CGFloat(gradientColors.count - 1)
        
        // Điều chỉnh phạm vi position dựa trên kích thước cửa sổ
        let minPosition: CGFloat = -screenWidth / 2
        let maxPosition: CGFloat = screenWidth * 1.5  // Mở rộng để đảm bảo màu không bị cắt
        
        // Chuẩn hóa position thành giá trị từ 0 -> 1
        let clampedPosition = min(max(position, minPosition), maxPosition)
        let relativePosition = (clampedPosition - minPosition) / (maxPosition - minPosition)
        
        // Tính toán vị trí màu trong mảng gradientColors
        let colorPosition = colorCount * relativePosition
        let startIndex = max(0, min(Int(floor(colorPosition)), gradientColors.count - 1))
        let endIndex = max(0, min(Int(ceil(colorPosition)), gradientColors.count - 1))
        let fraction = colorPosition - CGFloat(startIndex)

        #if os(iOS)
        let startColor = UIColor(gradientColors[startIndex])
        let endColor = UIColor(gradientColors[endIndex])
        let color = UIColor.interpolate(from: startColor, to: endColor, fraction: fraction)
        uiColor = color
        selectedColor = Color(color)
        #else
        let startColor = NSColor(gradientColors[startIndex])
        let endColor = NSColor(gradientColors[endIndex])
        let color = NSColor.interpolate(from: startColor, to: endColor, fraction: fraction)
        nsColor = color
        selectedColor = Color(color)
        #endif

        dragOffset = position
    }



}

// Tiện ích nội suy màu sắc
#if os(iOS)
import UIKit
typealias UniversalColor = UIColor
#else
import AppKit
typealias UniversalColor = NSColor
#endif

extension UniversalColor {
    static func interpolate(from color1: UniversalColor, to color2: UniversalColor, fraction: CGFloat) -> UniversalColor {
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        #if os(iOS)
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        #else
        let c1 = color1.usingColorSpace(.deviceRGB)!
        let c2 = color2.usingColorSpace(.deviceRGB)!
        c1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        c2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        #endif

        let r = r1 + (r2 - r1) * fraction
        let g = g1 + (g2 - g1) * fraction
        let b = b1 + (b2 - b1) * fraction
        let a = a1 + (a2 - a1) * fraction

        return UniversalColor(red: r, green: g, blue: b, alpha: a)
    }
}





// Test trên cả iOS và macOS
struct TestColorPicker: View {
    @State private var selectedColor: Color = .blue
    @State private var dragOffset: CGFloat = 0.0

    #if os(iOS)
    @State private var uiColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    #else
    @State private var nsColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    #endif
    
    var body: some View {
        HStack {
            #if os(iOS)
            CustomColorPicker(selectedColor: $selectedColor, dragOffset: $dragOffset, uiColor: $uiColor)
            #else
            CustomColorPicker(selectedColor: $selectedColor, dragOffset: $dragOffset, nsColor: $nsColor)
            #endif
        }
    }
}


struct ColorPicker_PreviewsX: PreviewProvider {
    static var previews: some View {
        TestColorPicker()
    }
}
