import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tshirt")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Henüz kombin eklenmemiş")
                .font(.headline)
            
            Text("Yeni bir kombin oluşturmak için + butonuna tıklayın")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}