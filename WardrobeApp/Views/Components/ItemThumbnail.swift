import SwiftUI

struct ItemThumbnail: View {
    let item: ClothingItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let imageData = item.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: item.category.icon)
                    .font(.system(size: 30))
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Text(item.brand)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}