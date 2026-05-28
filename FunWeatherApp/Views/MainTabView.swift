import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                WeatherView()
            }
            .tabItem {
                Label("Weather", systemImage: "cloud.sun.rain.fill")
            }
            NavigationView {
                UserActivityView()
            }
            .tabItem {
                Label("Activity", systemImage: "figure.run.circle.fill")
            }
            NavigationView {
                AboutView()
            }
                .tabItem {
                    Label("About", systemImage: "questionmark.message.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
