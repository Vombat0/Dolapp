import SwiftUI

struct SeasonBadge: View {
    let season: Season
    
    var icon: String {
        switch season {
        case .spring: return "leaf.arrow.circlepath"
        case .summer: return "sun.max"
        case .autumn: return "leaf"
        case .winter: return "snowflake"
        case .all: return "calendar"
        }
    }
    
    var color: Color {
        switch season {
        case .spring: return .green
        case .summer: return .orange
        case .autumn: return .brown
        case .winter: return .blue
        case .all: return .purple
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(season.rawValue)
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .foregroundColor(color)
        .cornerRadius(12)
    }
}