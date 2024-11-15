import SwiftUI
import PhotosUI
import Vision

struct AddClothingItemView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (ClothingItem) -> Void
    
    @State private var selectedBrand: Brand = .other
    @State private var customBrand = ""
    @State private var price = ""
    @State private var category = ClothingCategory.tops
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isProcessingImage = false
    @State private var selectedColor = "Siyah"
    @State private var selectedSeasons: Set<Season> = [.all]
    @State private var isFavorite = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Fotoğraf") {
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                        } else {
                            HStack {
                                Image(systemName: "photo")
                                Text("Fotoğraf Seç")
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(AppTheme.cornerRadius)
                        }
                    }
                    
                    if isProcessingImage {
                        ProgressView("Fotoğraf işleniyor...")
                    }
                }
                
                Section("Temel Bilgiler") {
                    Picker("Marka", selection: $selectedBrand) {
                        ForEach(Brand.grouped.keys.sorted(), id: \.self) { group in
                            Section(header: Text(group)) {
                                ForEach(Brand.grouped[group] ?? [], id: \.self) { brand in
                                    Text(brand.rawValue).tag(brand)
                                }
                            }
                        }
                    }
                    
                    if selectedBrand == .other {
                        TextField("Marka Adı", text: $customBrand)
                    }
                    
                    TextField("Fiyat", text: $price)
                        .keyboardType(.decimalPad)
                    
                    Picker("Kategori", selection: $category) {
                        ForEach(ClothingCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon).tag(category)
                        }
                    }
                }
                
                Section("Renk") {
                    ColorPickerView(selectedColor: $selectedColor)
                }
                
                Section("Sezon") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Season.allCases, id: \.self) { season in
                                SeasonBadge(season: season)
                                    .opacity(selectedSeasons.contains(season) ? 1 : 0.5)
                                    .onTapGesture {
                                        if season == .all {
                                            selectedSeasons = [.all]
                                        } else {
                                            selectedSeasons.remove(.all)
                                            if selectedSeasons.contains(season) {
                                                selectedSeasons.remove(season)
                                            } else {
                                                selectedSeasons.insert(season)
                                            }
                                            if selectedSeasons.isEmpty {
                                                selectedSeasons = [.all]
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                
                Section {
                    Toggle(isOn: $isFavorite) {
                        Label("Favorilere Ekle", systemImage: "heart.fill")
                            .foregroundColor(isFavorite ? .red : .primary)
                    }
                }
            }
            .navigationTitle("Yeni Kıyafet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        guard let priceValue = Double(price) else { return }
                        let brandName = selectedBrand == .other ? customBrand : selectedBrand.rawValue
                        let item = ClothingItem(
                            brand: brandName,
                            price: priceValue,
                            category: category,
                            image: imageData,
                            color: selectedColor,
                            season: Array(selectedSeasons),
                            favorite: isFavorite
                        )
                        onSave(item)
                        dismiss()
                    }
                    .disabled(selectedBrand == .other && customBrand.isEmpty || 
                            price.isEmpty || 
                            imageData == nil)
                }
            }
            .onChange(of: selectedImage) { _ in
                Task {
                    isProcessingImage = true
                    if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            let processedImage = await removeBackground(from: uiImage)
                            imageData = processedImage.jpegData(compressionQuality: 0.8)
                        }
                    }
                    isProcessingImage = false
                }
            }
        }
    }
    
    func removeBackground(from image: UIImage) async -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        
        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = .balanced
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        
        do {
            try handler.perform([request])
            
            guard let mask = request.results?.first?.pixelBuffer else {
                return image
            }
            
            let maskImage = CIImage(cvPixelBuffer: mask)
            let originalImage = CIImage(cgImage: cgImage)
            
            let scaleX = originalImage.extent.width / maskImage.extent.width
            let scaleY = originalImage.extent.height / maskImage.extent.height
            
            let scaledMask = maskImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
            guard let compositingFilter = CIFilter(name: "CIBlendWithMask") else {
                return image
            }
            
            compositingFilter.setValue(originalImage, forKey: kCIInputImageKey)
            compositingFilter.setValue(CIImage(color: .clear), forKey: kCIInputBackgroundImageKey)
            compositingFilter.setValue(scaledMask, forKey: kCIInputMaskImageKey)
            
            guard let outputImage = compositingFilter.outputImage,
                  let cgOutput = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
                return image
            }
            
            return UIImage(cgImage: cgOutput)
        } catch {
            print("Arka plan kaldırma hatası: \(error)")
            return image
        }
    }
}