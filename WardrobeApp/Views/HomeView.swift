import SwiftUI

struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var outfits: [Outfit] = []
    @State private var showingAddOutfit = false
    
    var filteredOutfits: [Outfit] {
        outfits.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    DatePicker("Tarih Seçin",
                             selection: $selectedDate,
                             displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding()
                    
                    if filteredOutfits.isEmpty {
                        EmptyStateView()
                    } else {
                        OutfitList(outfits: filteredOutfits)
                    }
                }
                .padding()
            }
            .navigationTitle("Günlük Kombinler")
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