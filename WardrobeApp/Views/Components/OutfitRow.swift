import SwiftUI

struct OutfitRow: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Tarih ve Not
            VStack(alignment: .leading, spacing: 4) {
                Text(outfit.date.formatted(date: .long, time: .omitted))
                    .font(.headline)
                
                if let note = outfit.note {
                    Text(note)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Kıyafetler
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(outfit.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Text(item.brand)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .frame(width: 60)
                    }
                }
            }
            
            // İstatistikler
            HStack(spacing: 16) {
                Label("\(outfit.items.count) parça", systemImage: "tshirt")
                Label(String(format: "%.2f ₺", outfit.items.reduce(0) { $0 + $1.price }), 
                      systemImage: "turkishlirasign")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}