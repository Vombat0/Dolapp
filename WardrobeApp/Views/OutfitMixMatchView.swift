import SwiftUI

struct OutfitMixMatchView: View {
    @State private var items: [ClothingItem] = []
    @State private var selectedItems: [ClothingCategory: ClothingItem] = [:]
    
    var categorizedItems: [ClothingCategory: [ClothingItem]] {
        Dictionary(grouping: items) { $0.category }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Üst Giyim
                    CategoryScrollSection(
                        title: "Üst Giyim",
                        items: categorizedItems[.tops] ?? [],
                        selectedItem: selectedItems[.tops],
                        onSelect: { item in
                            selectedItems[.tops] = item
                        }
                    )
                    
                    // Alt Giyim
                    CategoryScrollSection(
                        title: "Alt Giyim",
                        items: categorizedItems[.bottoms] ?? [],
                        selectedItem: selectedItems[.bottoms],
                        onSelect: { item in
                            selectedItems[.bottoms] = item
                        }
                    )
                    
                    // Dış Giyim
                    CategoryScrollSection(
                        title: "Dış Giyim",
                        items: categorizedItems[.outerwear] ?? [],
                        selectedItem: selectedItems[.outerwear],
                        onSelect: { item in
                            selectedItems[.outerwear] = item
                        }
                    )
                    
                    // Ayakkabı
                    CategoryScrollSection(
                        title: "Ayakkabı",
                        items: categorizedItems[.shoes] ?? [],
                        selectedItem: selectedItems[.shoes],
                        onSelect: { item in
                            selectedItems[.shoes] = item
                        }
                    )
                    
                    // Aksesuar
                    CategoryScrollSection(
                        title: "Aksesuar",
                        items: categorizedItems[.accessories] ?? [],
                        selectedItem: selectedItems[.accessories],
                        onSelect: { item in
                            selectedItems[.accessories] = item
                        }
                    )
                    
                    // Kombin Özeti
                    if !selectedItems.isEmpty {
                        OutfitSummaryCard(selectedItems: selectedItems)
                    }
                }
                .padding()
            }
            .navigationTitle("Kombin Oluştur")
            .onAppear {
                items = DataManager.shared.loadClothingItems()
            }
        }
    }
}

struct CategoryScrollSection: View {
    let title: String
    let items: [ClothingItem]
    let selectedItem: ClothingItem?
    let onSelect: (ClothingItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            if items.isEmpty {
                Text("Bu kategoride kıyafet bulunmuyor")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(items) { item in
                            ItemCard(
                                item: item,
                                isSelected: selectedItem?.id == item.id,
                                onSelect: { onSelect(item) }
                            )
                        }
                    }
                }
            }
        }
    }
}

struct ItemCard: View {
    let item: ClothingItem
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.brand)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(String(format: "%.2f ₺", item.price))
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 120)
        .onTapGesture(perform: onSelect)
    }
}

struct OutfitSummaryCard: View {
    let selectedItems: [ClothingCategory: ClothingItem]
    
    var totalPrice: Double {
        selectedItems.values.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Kombin Özeti")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(selectedItems.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { category in
                    if let item = selectedItems[category] {
                        HStack {
                            Text(category.rawValue)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(item.brand)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Toplam Değer")
                        .fontWeight(.medium)
                    Spacer()
                    Text(String(format: "%.2f ₺", totalPrice))
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            
            Button {
                let outfit = Outfit(
                    date: Date(),
                    items: Array(selectedItems.values),
                    note: "Kombin Oluşturucu ile oluşturuldu"
                )
                var outfits = DataManager.shared.loadOutfits()
                outfits.append(outfit)
                DataManager.shared.saveOutfits(outfits)
            } label: {
                Text("Kombini Kaydet")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
}