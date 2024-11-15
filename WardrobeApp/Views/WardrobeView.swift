// WardrobeView içindeki ClothingItemRow'da silme işlemi için swipe action ekleyelim
struct ClothingItemRow: View {
    let item: ClothingItem
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.brand)
                    .font(.headline)
                
                Text(item.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(String(format: "%.2f ₺", item.price))
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(item.wearCount) kez giyildi")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Sil", systemImage: "trash")
            }
        }
    }
}