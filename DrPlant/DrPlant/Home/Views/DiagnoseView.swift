import SwiftUI

struct PlantConditionView: View {
    let mainImage = "i"
    
    struct PlantInfo {
        let imageName: String
        let description: String
        let biological: String
        let chemical: String
        let prevention: String
        let probability: Double
    }
    
    let plantInfos = [
        PlantInfo(
            imageName: "i1",
            description: "Lack of water",
            biological: "For potted plants: if the soil is really dry, you may immerse the whole pot in water and wait until the soil absorbs the water.",
            chemical: "You may apply hydrogel for plants to the soil to increase water retention capacity.",
            prevention: "Mulch plants with a layer of organic mulch to reduce soil evaporation.",
            probability: 0.96
        ),
        PlantInfo(
            imageName: "i2",
            description: "Xanthomonas bacteria",
            biological: "Remove infected leaves and avoid overhead watering.",
            chemical: "Use copper-based fungicides to treat bacterial spots.",
            prevention: "Ensure proper plant spacing and air circulation.",
            probability: 0.45
        ),
        PlantInfo(
            imageName: "i3",
            description: "Too small pot",
            biological: "Repot the plant into a larger container with fresh soil.",
            chemical: "Use a balanced fertilizer to support new growth.",
            prevention: "Regularly check root growth and repot as necessary.",
            probability: 0.05
        )
    ]
    
    @State private var selectedImageIndex = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("DrPlant")
                        .padding(.bottom, 20)
                    Spacer()
                }
                Image(mainImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    ZStack(alignment: .center) {
                        ForEach(plantInfos.indices, id: \.self) { index in
                            VStack {
                                Image(plantInfos[index].imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 10)
                                    .blur(radius: selectedImageIndex == index ? 0 : 10)
                                    .offset(x: CGFloat(index - selectedImageIndex) * 220)
                                    .animation(.easeInOut, value: selectedImageIndex)
                                
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
                // Changing text under the carousel
                Text(plantInfos[selectedImageIndex].description)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Treatment")
                        .font(.headline)
                        .padding(.vertical, 5)
                    
                    Group {
                        Text("biological:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text(plantInfos[selectedImageIndex].biological)
                            .padding(.leading, 10)
                        
                        Text("chemical:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        Text(plantInfos[selectedImageIndex].chemical)
                            .padding(.leading, 10)
                        
                        Text("prevention:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        Text(plantInfos[selectedImageIndex].prevention)
                            .padding(.leading, 10)
                    }
                }
                .padding(.horizontal, 10)
                
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

struct PlantConditionView_Previews: PreviewProvider {
    static var previews: some View {
        PlantConditionView()
    }
}

