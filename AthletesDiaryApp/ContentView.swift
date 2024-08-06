//import SwiftUI
import UserNotifications
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var accentColor: Color {
        switch selectedTab {
        case 0:
            return Color(hex: "#f2545b")
        case 2:
            return Color(hex: "#c4ff00")
        default:
            return Color("accentColor")
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainScreen()
                .tag(0)
                .tabItem {
                    Image(systemName: "homekit")
                    Text("Main")
                }
            WorkoutScreen()
                .tag(1)
                .tabItem {
                    Image(systemName: "figure.highintensity.intervaltraining")
                    Text("Workout")
                }
            DietScreen()
                .tag(2)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Diet")
                }
            ProfileScreen()
                .tag(3)
                .tabItem {
                    Image(systemName: "ellipsis.circle.fill")
                    Text("More")
                }
        }
        .accentColor(accentColor)
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Permission approved!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// Helper extension to initialize Color with hex strings
extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0
        let r, g, b: Double

        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }

        if scanner.scanHexInt64(&hexNumber) {
            r = Double((hexNumber & 0xff0000) >> 16) / 255
            g = Double((hexNumber & 0x00ff00) >> 8) / 255
            b = Double(hexNumber & 0x0000ff) / 255
            self.init(red: r, green: g, blue: b)
        } else {
            self.init(red: 0, green: 0, blue: 0)
        }
    }
}

#Preview {
    ContentView()
}
