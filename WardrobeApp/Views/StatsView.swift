import SwiftUI

struct StatsView: View {
    @State private var items: [ClothingItem] = []
    @State private var selectedTimeRange: TimeRange = .allTime
    @State private var showingFilters = false
    
    enum TimeRange: String, CaseIterable {
        case week = "Bu Hafta"
        case month = "Bu Ay"
        case year = "Bu Yıl"
        case allTime = "Tüm Zamanlar"
    }
    
    var filteredItems: [ClothingItem] {
        items.filter { item in
            switch selectedTimeRange {
            case .week:
                return Calendar.current.isDate(item.purchaseDate, equalTo: Date(), toGranularity: .weekOfYear)
            case .month:
                return Calendar.current.isDate(item.purchaseDate, equalTo: Date(), toGranularity: .month)
            case .year:
                return Calendar.current.isDate(item.purchaseDate, equalTo: Date(), toGranularity: .year)
            case .allTime:
                return true
            }
        }
    }
    
    var totalSpent: Double {
        filteredItems.reduce(0) { $0 + $1.price }
    }
    
    var mostWornCategory: (ClothingCategory, Int)? {
        let grouped = Dictionary(grouping: filteredItems) { $0.category }
        return grouped.map { ($0.key, $0.value.count) }.max { $0.1 < $1.1 }
    }
    
    var mostExpensiveItem: ClothingItem? {
        filteredItems.max { $0.price < $1.price }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Zaman Aralığı Seçici
                    Picker("Zaman Aralığı", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // İstatistik Kartları
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatsCard(
                            title: "Toplam Harcama",
                            value: String(format: "%.2f ₺", totalSpent),
                            icon: "turkishlirasign.circle.fill",
                            color: .blue
                        )
                        
                        StatsCard(
                            title: "Toplam Parça",
                            value: "\(filteredItems.count)",
                            icon: "tshirt.fill",
                            color: .purple
                        )
                        
                        if let (category, count) = mostWornCategory {
                            StatsCard(
                                title: "En Çok Giyilen Kategori",
                                value: "\(category.rawValue)\n(\(count) parça)",
                                icon: category.icon,
                                color: .green
                            )
                        }
                        
                        if let item = mostExpensiveItem {
                            StatsCard(
                                title: "En Pahalı Parça",
                                value: "\(item.brand)\n\(String(format: "%.2f ₺", item.price))",
                                icon: "star.fill",
                                color: .orange
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Kategori Dağılımı
                    CategoryDistributionChart(items: filteredItems)
                        .frame(height: 200)
                        .padding()
                    
                    // Sezon Dağılımı
                    SeasonDistributionChart(items: filteredItems)
                        .frame(height: 200)
                        .padding()
                }
            }
            .navigationTitle("İstatistikler")
            .background(AppTheme.gradientBackground())
            .onAppear {
                items = DataManager.shared.loadClothingItems()
            }
        }
    }
}

struct CategoryDistributionChart: View {
    let items: [ClothingItem]
    
    var categoryData: [(ClothingCategory, Double)] {
        let grouped = Dictionary(grouping: items) { $0.category }
        let total = Double(items.count)
        return ClothingCategory.allCases.map { category in
            let count = Double(grouped[category]?.count ?? 0)
            return (category, (count / total) * 100)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Kategori Dağılımı")
                .font(.headline)
                .padding(.bottom)
            
            ForEach(categoryData, id: \.0) { category, percentage in
                HStack {
                    Text(category.rawValue)
                        .font(.caption)
                        .frame(width: 100, alignment: .leading)
                    
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.primary)
                            .frame(width: geometry.size.width * (percentage / 100))
                    }
                    
                    Text(String(format: "%.1f%%", percentage))
                        .font(.caption)
                        .frame(width: 50)
                }
                .frame(height: 20)
            }
        }
    }
}

struct SeasonDistributionChart: View {
    let items: [ClothingItem]
    
    var seasonData: [(Season, Int)] {
        var counts: [Season: Int] = [:]
        items.forEach { item in
            item.season.forEach { season in
                counts[season, default: 0] += 1
            }
        }
        return Season.allCases.map { ($0, counts[$0] ?? 0) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sezon Dağılımı")
                .font(.headline)
                .padding(.bottom)
            
            HStack(spacing: 16) {
                ForEach(seasonData, id: \.0) { season, count in
                    VStack {
                        Text("\(count)")
                            .font(.headline)
                        
                        SeasonBadge(season: season)
                    }
                }
            }
        }
    }
}