import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let defaults = UserDefaults.standard
    private let outfitsKey = "savedOutfits"
    private let itemsKey = "savedItems"
    
    private init() {}
    
    func saveOutfits(_ outfits: [Outfit]) {
        if let encoded = try? JSONEncoder().encode(outfits) {
            defaults.set(encoded, forKey: outfitsKey)
        }
    }
    
    func loadOutfits() -> [Outfit] {
        guard let data = defaults.data(forKey: outfitsKey),
              let outfits = try? JSONDecoder().decode([Outfit].self, from: data) else {
            return []
        }
        return outfits
    }
    
    func saveClothingItems(_ items: [ClothingItem]) {
        if let encoded = try? JSONEncoder().encode(items) {
            defaults.set(encoded, forKey: itemsKey)
        }
    }
    
    func loadClothingItems() -> [ClothingItem] {
        guard let data = defaults.data(forKey: itemsKey),
              let items = try? JSONDecoder().decode([ClothingItem].self, from: data) else {
            return []
        }
        return items
    }
}