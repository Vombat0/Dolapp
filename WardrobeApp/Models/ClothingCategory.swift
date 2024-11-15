import Foundation

enum ClothingCategory: String, Codable, CaseIterable {
    case tops = "Üst Giyim"
    case bottoms = "Alt Giyim"
    case dresses = "Elbise"
    case outerwear = "Dış Giyim"
    case shoes = "Ayakkabı"
    case accessories = "Aksesuar"
    
    var icon: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "scissors"
        case .dresses: return "person.crop.rectangle"
        case .outerwear: return "leaf"
        case .shoes: return "shoe"
        case .accessories: return "crown"
        }
    }
}