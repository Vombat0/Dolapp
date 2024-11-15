import SwiftUI

struct OutfitDetailView: View {
    let outfit: Outfit
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Tarih ve Not
                    VStack(alignment: .leading, spacing: 8) {
                        Text(outfit.date.formatted(date: .long, time: .omitted))
                            .font(.headline)
                        
                        if let note = outfit.note {
                            Text(note)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Kıyafetler
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Kombindeki Kıyafetler")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(outfit.items) { item in
                                    VStack(alignment: .leading, spacing: 8) {
                                        if let imageData = item.image, 
                                           let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 120, height: 120)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.brand)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            
                                            Text(item.category.rawValue)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            Text(String(format: "%.2f ₺", item.price))
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .frame(width: 120)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Kombin İstatistikleri
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Kombin İstatistikleri")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            StatRow(title: "Toplam Değer", 
                                  value: String(format: "%.2f ₺", outfit.items.reduce(0) { $0 + $1.price }))
                            
                            StatRow(title: "Parça Sayısı", 
                                  value: "\(outfit.items.count) parça")
                            
                            StatRow(title: "Ortalama Parça Maliyeti", 
                                  value: String(format: "%.2f ₺", 
                                              outfit.items.reduce(0) { $0 + $1.price } / Double(outfit.items.count)))
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Kombin Detayı")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Kapat") {
                    dismiss()
                }
            }
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}