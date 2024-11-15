import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: String
    
    let colors = [
        "Siyah", "Beyaz", "Gri", "Lacivert", "Mavi",
        "Kırmızı", "Yeşil", "Sarı", "Pembe", "Mor",
        "Kahverengi", "Bej", "Turuncu", "Bordo", "Altın",
        "Gümüş", "Çok Renkli"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(colors, id: \.self) { color in
                    Text(color)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedColor == color ? AppTheme.primary : Color.gray.opacity(0.1))
                        .foregroundColor(selectedColor == color ? .white : .primary)
                        .cornerRadius(16)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}