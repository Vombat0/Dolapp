import Foundation

struct Outfit: Identifiable, Codable {
    let id: UUID
    let date: Date
    let items: [ClothingItem]
    let note: String?
    
    init(id: UUID = UUID(), date: Date = Date(), items: [ClothingItem], note: String? = nil) {
        self.id = id
        self.date = date
        self.items = items
        self.note = note
    }
}