import SwiftUI

struct OutfitList: View {
    let outfits: [Outfit]
    
    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(outfits) { outfit in
                OutfitCard(outfit: outfit)
            }
        }
    }
}

struct OutfitCard: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(outfit.date.formatted(date: .long, time: .omitted))
                    .font(.headline)
                Spacer()
                Text("\(outfit.items.count) parça")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let note = outfit.note {
                Text(note)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(outfit.items) { item in
                        ItemThumbnail(item: item)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}