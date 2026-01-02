import SwiftUI

struct SlideView: View {
    let imageName: String
    let description: String
    @StateObject var screenSizeModel = ScreenSizeModel()
    @AppStorage("infomation") var information = true
    @Binding var showPopup: Bool
    
    @State var slimeCubeConfiguration = PrismConfiguration(
        tilt: 0.2,
        size: CGSize(width: 200, height: 200),
        extrusion: 20,
        levitation: 0,
        shadowOpacity: 0.3
    )
    @State var slimeCubeConfigurationCheckMark = PrismConfiguration(
        tilt: 0.2,
        size: CGSize(width: 100, height: 100),
        extrusion: 20,
        levitation: 0,
        shadowOpacity: 0.3
    )
    @State var smallSlimeCubeConfiguration = [
        PrismConfiguration (
        tilt: 0.2,
        size: CGSize(width: 40, height: 40),
        extrusion: 10,
        levitation: 0,
        shadowOpacity: 0.3),
        PrismConfiguration (
        tilt: 0.2,
        size: CGSize(width: 60, height: 60),
        extrusion: 20,
        levitation: 0,
        shadowOpacity: 0.3),
        PrismConfiguration (
        tilt: 0.2,
        size: CGSize(width: 80, height: 80),
        extrusion: 30,
        levitation: 0,
        shadowOpacity: 0.3),
        PrismConfiguration (
        tilt: 0.2,
        size: CGSize(width: 100, height: 100),
        extrusion: 40,
        levitation: 0,
        shadowOpacity: 0.3)
    ]
    @State var smallSlimeCubeColor = [Color.Red, Color.Green, Color.Blue, Color.Orange]
    
    @State var imageScale: CGFloat = 1
    var standardColors: [Color] = [.Red, .Blue, .Green, .Orange, .Purple, .Gray, .Brown, .Cyan]
    @State var cubeColor = Color.Green
    
    
    var body: some View {
        VStack(spacing: 15) {
            if description == "FLOOD IT!" {
                HStack (spacing: 15){
                    ForEach(0...3, id: \.self) { col in
                        PrismView(configuration: smallSlimeCubeConfiguration[col]) {
                            smallSlimeCubeColor[col]
                                .opacity(1)
                        } left: {
                            smallSlimeCubeColor[col].brightness(-0.1)
                                .opacity(0.8)
                        } right: {
                            smallSlimeCubeColor[col].brightness(-0.3)
                                .opacity(0.8)
                        }
                        .onTapGesture {
                            withAnimation(
                                .easeOut(duration: 0.32)
                            ) {
                                smallSlimeCubeConfiguration[col].extrusion = 0
                                smallSlimeCubeConfiguration[col].size = .init(
                                    width: 30,
                                    height: 30
                                )
                                var color = standardColors.randomElement() ?? .Green
                                while smallSlimeCubeColor[col] == color {
                                    color = standardColors.randomElement() ?? .Green
                                }
                                smallSlimeCubeColor[col] = color
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                                withAnimation(
                                    .interactiveSpring(response: 0.4, dampingFraction: 0.4)
                                ) {
                                    smallSlimeCubeConfiguration[col].extrusion = 25
                                    smallSlimeCubeConfiguration[col].size = .init(
                                        width: 75,
                                        height: 75
                                    )
                                }
                            }
                        }
                        .onAppear {
                            smallSlimeCubeColor[col] = standardColors.randomElement() ?? .Green
                        }
                        .onChange(of: smallSlimeCubeColor[col]) { newValue in
                            var isSimilar = true
                            for i in 1...3 {if smallSlimeCubeColor[i] != smallSlimeCubeColor[0] {isSimilar = false}}
                            if isSimilar {
                                for i in 0...3 {
                                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.4)) {
                                        smallSlimeCubeConfiguration[i].extrusion = CGFloat(i * 10 + 10)
                                        smallSlimeCubeConfiguration[i].size = CGSize(width: i * 20 + 40, height: i * 20 + 40)
                                        smallSlimeCubeColor[i] = standardColors.randomElement() ?? .Green
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if !(imageName == "delete") {
                PrismView(configuration: slimeCubeConfiguration) {
                    cubeColor
                        .opacity(1)
                } left: {
                    cubeColor.brightness(-0.1)
                        .opacity(0.8)
                } right: {
                    cubeColor.brightness(-0.3)
                        .opacity(0.8)
                }
                .onTapGesture {
                    withAnimation(
                        .easeOut(duration: 0.32)
                    ) {
                        slimeCubeConfiguration.extrusion = 0
                        slimeCubeConfiguration.size = .init(
                            width: 120,
                            height: 120
                        )
                        imageScale *= 0.5
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                        withAnimation(
                            .interactiveSpring(response: 0.4, dampingFraction: 0.4)
                        ) {
                            slimeCubeConfiguration.extrusion = 20
                            slimeCubeConfiguration.size = .init(
                                width: 200,
                                height: 200
                            )
                            imageScale = 1
                        }
                    }
                }
                .overlay() {
                    if imageName == "Clock" {
                        Image("Clock")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.offWhite)
                            .frame(maxWidth: 120, maxHeight: 120)
                            .offset(x: -3, y: -20)
                            .scaleEffect(imageScale)
                            .shadow(radius: 4)
                    } else {
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.offWhite)
                            .frame(maxWidth: 120, maxHeight: 120)
                            .offset(x: -3, y: -20)
                            .scaleEffect(imageScale)
                            .shadow(radius: 4)
                    }
                }
                .onAppear {
                    cubeColor = standardColors.randomElement() ?? .Green
                }
                .frame(width: 200, height: 200)
            }
                
            
            Text(description)
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.offWhite)
                .minimumScaleFactor(0.5)
                .padding(.horizontal)
                
            if imageName == "heart.fill" {
                PrismView(configuration: slimeCubeConfigurationCheckMark) {
                    Color.red
                        .overlay() {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.white)
                                .font(.system(size: 80, weight: .black))
                                .brightness(-0.3)
                                .transition(.scale)
                        }
                        .opacity(1)
                } left: {
                    Color.red.brightness(-0.1)
                        .opacity(0.8)
                } right: {
                    Color.red.brightness(-0.3)
                        .opacity(0.8)
                }
                .onTapGesture {
                    withAnimation(
                        .easeOut(duration: 0.32)
                    ) {
                        slimeCubeConfigurationCheckMark.extrusion = 5
                        slimeCubeConfigurationCheckMark.levitation = 5
                        slimeCubeConfigurationCheckMark.size = .init(
                            width: 100 * 0.75,
                            height: 100 * 0.75
                        )
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(
                            .interactiveSpring(response: 0.4, dampingFraction: 0.4)
                        ) {
                            slimeCubeConfiguration.extrusion = 20
                            slimeCubeConfiguration.size = .init(
                                width: 100,
                                height: 100
                            )
                        }
                        withAnimation(.easeInOut(duration: 0.5)) {
                            information = false
                            showPopup = false
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: screenSizeModel.SCREEN_SIZE.width - 120, maxHeight: screenSizeModel.SCREEN_SIZE.height)
        .background(Color.darkGray)
        .shadow(radius: 10)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct NoteGuide: View {
    @Binding var showPopup: Bool
    @State private var currentSlide = 0
    let totalSlides = 10

    var body: some View {
        ZStack {
            if showPopup {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showPopup = false
                            currentSlide = 0
                        }
                    }
                    .transition(.opacity)
            }
            if showPopup {
                PagingView(pages: 13) {
                    Group {
                        SlideView(imageName: "", description: "FLOOD IT!", showPopup: $showPopup)
                        SlideView(imageName: "delete", description: "'Flood It' is a fun puzzle game. The goal is to make the whole board one color. You start at the top-left. Each turn, pick a color in the color palette. This color will fill your area and any same-colored squares next to it. You win by making the entire board one color before you run out of moves, and you receive coins.", showPopup: $showPopup)
                        
                        SlideView(imageName: "arrow.counterclockwise.circle.fill", description: "Press this button to reset the game.", showPopup: $showPopup)
                        SlideView(imageName: "key.fill", description: "Press this button to show solution before the game starts. It costs 3 coins.", showPopup: $showPopup)
                        SlideView(imageName: "gearshape.circle.fill", description: "Press this button to show different mode.", showPopup: $showPopup)
                        SlideView(imageName: "circle.grid.2x2.fill", description: "This is normal mode.", showPopup: $showPopup)
                        SlideView(imageName: "eye.fill", description: "This is dizzy color mode.", showPopup: $showPopup)
                        SlideView(imageName: "hand.tap.fill", description: "This is custom mode. You can customize the board and colors, or just one of them. When you customize the board and colors, make sure that the color palette contains all the colors present on the board. It costs 3 coins.", showPopup: $showPopup)
                        SlideView(imageName: "list.bullet.circle.fill", description: "Press this button to choose the board size. There are 3 options: 8x8, 10x10 and 12x12", showPopup: $showPopup)
                        SlideView(imageName: "dollarsign.circle.fill", description: "Press this button to show your coin.", showPopup: $showPopup)
                    }
                    Group {
                        SlideView(imageName: "circle.hexagonpath.fill", description: "Press this button to show the bomb. When the bomb explodes, all the surrounding cubes will have the same color. To set the bomb, tap a cube on the board. Each bomb costs 2 coins.", showPopup: $showPopup)
                        SlideView(imageName: "Clock", description: "Press this button to activate Time Mode. You'll receive more money if you win in this mode.", showPopup: $showPopup)
                        SlideView(imageName: "heart.fill", description: "", showPopup: $showPopup)
                    }
                }
                .transition(.move(edge: .top))
                .padding()
            }
        }
    }
}

struct PopUp: View {
    @State private var showHelpPopup = false

    var body: some View {
        ZStack {
            Color.darkGray.opacity(0.3)
                .ignoresSafeArea()

            Button("Show Guide") {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5)) {
                    showHelpPopup.toggle()
                }
            }
            .font(.title)

            NoteGuide(showPopup: $showHelpPopup)
        }
    }
}
import SwiftUI

struct PagingView<Content: View>: View {
    let pages: Int
    let content: Content

    @GestureState private var dragOffset: CGFloat = 0
    @State private var currentPage: Int = 0

    init(pages: Int, @ViewBuilder content: () -> Content) {
        self.pages = pages
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 40) {
                self.content
                    .frame(width: geometry.size.width)
                    .transition(.scale)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentPage) * (geometry.size.width + 40) + self.dragOffset)
            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.6), value: currentPage)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = geometry.size.width / 10
                        var newIndex = self.currentPage

                        if value.translation.width < -threshold {
                            newIndex = min(newIndex + 1, self.pages - 1)
                        } else if value.translation.width > threshold {
                            newIndex = max(newIndex - 1, 0)
                        }

                        self.currentPage = newIndex
                    }
            )
        }
    }
}



struct UnitConverterGuide_Previews: PreviewProvider {
    static var previews: some View {
        PopUp()
    }
}
