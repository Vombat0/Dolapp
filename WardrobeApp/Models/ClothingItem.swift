import Foundation

struct ClothingItem: Identifiable, Codable {
    let id: UUID
    let brand: String
    let category: ClothingCategory
    let price: Double
    let image: Data?
    let purchaseDate: Date
    var wearCount: Int
    var color: String
    var favorite: Bool
    var season: [Season]
    
    init(id: UUID = UUID(),
         brand: String,
         price: Double,
         category: ClothingCategory,
         image: Data? = nil,
         purchaseDate: Date = Date(),
         wearCount: Int = 0,
         color: String = "Siyah",
         favorite: Bool = false,
         season: [Season] = [.all]) {
        self.id = id
        self.brand = brand
        self.price = price
        self.category = category
        self.image = image
        self.purchaseDate = purchaseDate
        self.wearCount = wearCount
        self.color = color
        self.favorite = favorite
        self.season = season
    }
}