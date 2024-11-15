import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var todaysOutfits: [Outfit] = []
    @Published var showingAddOutfit = false
    
    private var cancellables = Set<AnyCancellable>()
    private let dataManager = DataManager.shared
    
    init() {
        setupBindings()
        loadOutfits()
    }
    
    private func setupBindings() {
        $selectedDate
            .sink { [weak self] date in
                self?.filterOutfits(for: date)
            }
            .store(in: &cancellables)
    }
    
    private func loadOutfits() {
        todaysOutfits = dataManager.loadOutfits()
        filterOutfits(for: selectedDate)
    }
    
    private func filterOutfits(for date: Date) {
        todaysOutfits = dataManager.loadOutfits().filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
}