import SwiftUI

struct AppTheme {
    static let primary = Color("PrimaryColor")
    static let secondary = Color("SecondaryColor")
    static let accent = Color("AccentColor")
    static let background = Color("BackgroundColor")
    static let surface = Color("SurfaceColor")
    static let text = Color("TextColor")
    static let textSecondary = Color("TextSecondaryColor")
    
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    
    static func gradientBackground() -> some View {
        LinearGradient(
            colors: [primary.opacity(0.1), secondary.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}