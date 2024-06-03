//
//  DiagnoseView.swift
//  DrPlant
//
//  Created by Alisa Pogodaeva on 02.06.24.
//

import SwiftUI

struct PlantConditionView: View {
    let mainImage = "homeimage" // Replace with your main image name
    let images = ["homeimage", "homeimage", "homeimage"] // Replace with your carousel image names
    
    @State private var selectedImageIndex = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("DrPlant")
                Spacer()
                
                // Main Image
                Image(mainImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Image Carousel
                ZStack(alignment: .center) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150) 
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
                            .blur(radius: selectedImageIndex == index ? 0 : 10)
                            .offset(x: CGFloat(index - selectedImageIndex) * 220)
                            .animation(.easeInOut)
                    }
                }
                .frame(height: 200) // Adjust height here
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {
                                if selectedImageIndex < images.count - 1 {
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
                .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Treatment")
                        .font(.headline)
                        .padding(.vertical, 5)
                    
                    Group {
                        Text("biological:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text("For potted plants: if the soil is really dry, you may immerse the whole pot in water and wait until the soil absorbs the water.")
                            .padding(.leading, 10)
                        
                        Text("chemical:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        Text("You may apply hydrogel for plants to the soil to increase water retention capacity.")
                            .padding(.leading, 10)
                        
                        Text("prevention:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        Text("Mulch plants with a layer of organic mulch to reduce soil evaporation.")
                            .padding(.leading, 10)
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct PlantConditionView_Previews: PreviewProvider {
    static var previews: some View {
        PlantConditionView()
    }
}
