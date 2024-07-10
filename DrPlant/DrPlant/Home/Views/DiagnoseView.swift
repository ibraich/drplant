import SwiftUI

struct PlantConditionView: View {
    let mainImage: UIImage?
    var model_diagnose: HealthAssessmentModel?
    
    struct PlantInfo {
        let name: String
        let probability: Double
        let imageURL: URL // Store image URL
        let localName: String
        let description: String
        let chemical: [String]?
        let biological: [String]?
        let prevention: [String]?
        init(name: String, probability: Double, imageURL: URL, localName: String, description: String,chemical: [String]?, biological: [String]?, prevention: [String]?) {
            self.name = name
            self.probability = probability
            self.imageURL = imageURL
            self.localName = localName
            self.description = description
            self.chemical = chemical
            self.biological = biological
            self.prevention = prevention
        }
    }
    
    var plantInfos: [PlantInfo] {
        guard let model_diagnose = model_diagnose else {
            return [] // Return empty array if model_diagnose is nil
        }
        
        guard model_diagnose.result.disease.suggestions.count >= 3 else {
            return [] // Return empty array if there are fewer than 3 suggestions
        }
        
        var infos: [PlantInfo] = []
        
        for i in 0..<3 { // Loop through the first three suggestions
            let suggestion = model_diagnose.result.disease.suggestions[i]
            
            // Check if the suggestion has at least one similar image
            if let firstSimilarImage = suggestion.similarImages.first {
                // Create PlantInfo instance with imageURL as URL
                if let url = URL(string: firstSimilarImage.url) {
                    let plantInfo = PlantInfo(
                        name: suggestion.name,
                        probability: suggestion.probability,
                        imageURL: url,
                        localName: suggestion.details.localName,
                        description: suggestion.details.description,
                        chemical: suggestion.details.treatment.chemical,
                        biological: suggestion.details.treatment.biological,
                        prevention: suggestion.details.treatment.prevention
                    )
                    infos.append(plantInfo)
                }
            }
        }
        
        return infos
    }
    
    @State private var selectedImageIndex = 0 // Track selected image index
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("DrPlant")
                        .padding(.bottom, 20)
                    Spacer()
                }
                
                Image(uiImage: mainImage ?? UIImage(imageLiteralResourceName: "homeimage"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height:150)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    ZStack(alignment: .center) {
                        ForEach(plantInfos.indices, id: \.self) { index in
                            VStack {
                                AsyncImage(url: plantInfos[index].imageURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                            .padding(.horizontal, 10)
                                            .offset(x: CGFloat(index - selectedImageIndex) * 220)
                                            .animation(.easeInOut, value: selectedImageIndex)
                                    case .failure:
                                        Text("Failed to load")
                                            .foregroundColor(.red)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                if selectedImageIndex == index {
                                    Text(getProbabilityLabel(probability: plantInfos[index].probability))
                                        .font(.subheadline) // Adjust the font size here
                                        .padding(.top, 5)
                                        .foregroundColor(getProbabilityColor(probability: plantInfos[index].probability))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: 200) // Adjust height here
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {
                                if selectedImageIndex < plantInfos.count - 1 {
                                    selectedImageIndex += 1
                                }
                            }
                            if value.translation.width > 50 {
                                if selectedImageIndex > 0 {
                                    selectedImageIndex -= 1
                                }
                            }
                        }
                )
                .padding(.horizontal, 10)
                
                if selectedImageIndex < plantInfos.count {
                    // Description and other details
                    Text(plantInfos[selectedImageIndex].name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(plantInfos[selectedImageIndex].description)
                        .font(.body)
                        .padding(.bottom, 10)
                    if let chemical = plantInfos[selectedImageIndex].chemical {
                        Text("Chemical Treatment:")
                            .font(.headline)
                            .padding(.top, 10)
                        ForEach(chemical, id: \.self) { item in
                            Text(item)
                                .font(.subheadline)
                                .padding(.leading, 10)
                        }
                    }
                    
                    if let prevention = plantInfos[selectedImageIndex].prevention {
                        Text("Prevention:")
                            .font(.headline)
                            .padding(.top, 10)
                        ForEach(prevention, id: \.self) { item in
                            Text(item)
                                .font(.subheadline)
                                .padding(.leading, 10)
                        }
                    }
                } else {
                    Text("Sorry! Somethıng ıs wrong")
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    func getProbabilityLabel(probability: Double) -> String {
        if probability < 0.10 {
            return "Low Probability"
        } else if probability < 0.60 {
            return "Medium Probability"
        } else {
            return "High Probability"
        }
    }
    
    func getProbabilityColor(probability: Double) -> Color {
        if probability < 0.10 {
            return .red
        } else if probability < 0.60 {
            return .yellow
        } else {
            return .green
        }
    }
}

struct AsyncImage<Content: View>: View {
    @StateObject private var loader: ImageLoader
    private let content: (AsyncImagePhase) -> Content
    
    init(url: URL, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.content = content
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        content(loader.phase)
            .onAppear(perform: loader.load)
    }
}

enum AsyncImagePhase {
    case empty
    case success(Image)
    case failure
}

class ImageLoader: ObservableObject {
    @Published var phase: AsyncImagePhase = .empty
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let uiImage = UIImage(data: data) {
                    self.phase = .success(Image(uiImage: uiImage))
                } else {
                    self.phase = .failure
                }
            }
        }.resume()
    }
}
