import SwiftUI

struct TimerView: View {
    @State private var timeRemaining = 60
    @State private var timerRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("\(timeRemaining)")
                .font(.largeTitle)
                .padding()
            
            HStack {
                Button(action: startTimer) {
                    Text("Start")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: pauseTimer) {
                    Text("Pause")
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                Button(action: resetTimer) {
                    Text("Reset")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    
    func startTimer() {
        guard !timerRunning else { return }
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timerRunning = false
            }
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timerRunning = false
    }
    
    func resetTimer() {
        pauseTimer()
        timeRemaining = 60
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
