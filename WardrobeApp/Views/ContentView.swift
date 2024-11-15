import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            WardrobeView()
                .tabItem {
                    Label("Dolabım", systemImage: "tshirt.fill")
                }
            
            OutfitMixMatchView()
                .tabItem {
                    Label("Kombin", systemImage: "square.grid.2x2")
                }
            
            StatsView()
                .tabItem {
                    Label("İstatistik", systemImage: "chart.bar.fill")
                }
        }
        .tint(.blue)
    }
}