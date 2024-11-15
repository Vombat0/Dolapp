import SwiftUI

struct OutfitsView: View {
    @State private var outfits: [Outfit] = []
    @State private var showingAddOutfit = false
    
    var body: some View {
        NavigationView {
            List(outfits) { outfit in
                OutfitRow(outfit: outfit)
            }
            .navigationTitle("Kombinlerim")
            .toolbar {
                Button {
                    showingAddOutfit = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddOutfit) {
                AddOutfitView { newOutfit in
                    outfits.append(newOutfit)
                    DataManager.shared.saveOutfits(outfits)
                }
            }
            .onAppear {
                outfits = DataManager.shared.loadOutfits()
            }
        }
    }
}

struct AddOutfitView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (Outfit) -> Void
    
    @State private var selectedDate = Date()
    @State private var selectedItems: Set<UUID> = []
    @State private var note = ""
    @State private var availableItems: [ClothingItem] = []
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Tarih", selection: $selectedDate, displayedComponents: [.date])
                
                Section("Kıyafetler") {
                    ForEach(availableItems) { item in
                        HStack {
                            if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(item.brand)
                                Text(item.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedItems.contains(item.id) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedItems.contains(item.id) {
                                selectedItems.remove(item.id)
                            } else {
                                selectedItems.insert(item.id)
                            }
                        }
                    }
                }
                
                Section("Not") {
                    TextEditor(text: $note)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Yeni Kombin")
            .toolbar {
                Button("Kaydet") {
                    let selectedClothes = availableItems.filter { selectedItems.contains($0.id) }
                    let outfit = Outfit(
                        date: selectedDate,
                        items: selectedClothes,
                        note: note.isEmpty ? nil : note
                    )
                    onSave(outfit)
                    dismiss()
                }
                .disabled(selectedItems.isEmpty)
            }
            .onAppear {
                availableItems = DataManager.shared.loadClothingItems()
            }
        }
    }
}