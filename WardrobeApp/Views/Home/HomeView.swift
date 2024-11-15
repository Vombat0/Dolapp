import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    CalendarView(selectedDate: $viewModel.selectedDate)
                    
                    if viewModel.todaysOutfits.isEmpty {
                        EmptyStateView()
                    } else {
                        OutfitList(outfits: viewModel.todaysOutfits)
                    }
                }
                .padding()
            }
            .navigationTitle("Günlük Kombinler")
            .toolbar {
                Button {
                    viewModel.showingAddOutfit = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingAddOutfit) {
                AddOutfitView()
            }
        }
    }
}