//
//  PlantView.swift
//  DrPlant
//
//  Created by Adam Bokun on 10.06.24.
//

import SwiftUI
import Kingfisher

struct PlantView: View {

    
    let mainImage: UIImage?
    var model: IdentificationModel?
    var model_diagnose: HealthAssessmentModel?
    let images = ["homeimage", "homeimage", "homeimage"]
    let information = [["Shiitake",
                        "East Asia",
                        "The shiitake is an edible mushroom native to East Asia, which is cultivated and consumed around the globe."],
                       ["Miso",
                        "Japan",
                        "Miso is a traditional Japanese seasoning produced by fermenting soybeans with salt and koji (the fungus Aspergillus oryzae) and sometimes rice, barley, or other ingredients."],
                       ["Green Tea",
                        "China",
                        "Originating in China, green tea has been cultivated and consumed in East Asia for centuries."]]
    
    @State private var selectedImageIndex = 0
    @State private var showNextButton = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    Text("DrPlant")
                        .padding(.bottom, 5)
                    Spacer()
                    
                    Image(uiImage: mainImage ?? UIImage(imageLiteralResourceName: "homeimage"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Image Carousel
                    ZStack(alignment: .center) {
                        ForEach(images.indices, id: \.self) { index in
                            KFImage(URL(string: model?.result.classification.suggestions[index].similarImages[0].url ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(10)
                                .padding(.horizontal, 10)
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
                    
                    if showNextButton {
                        Text("Does your plant look like").font(.title3)
                            .padding(.bottom, 5)
                    }
                    
                    HStack {
                        Spacer()
                        Text(model?.result.classification.suggestions[0].name ?? "").font(.title)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    HStack {
                        Spacer()
//                        Text(model?.result.classification.suggestions[selectedImageIndex].probability ?? 0).font(.title3)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    if showNextButton {
                        HStack {
                            Button {
                                showNextButton.toggle()
                            } label: {
                                Image(systemName: "hand.thumbsup.circle").resizable().frame(width: 70, height: 70)
                                    .foregroundColor(Color.black)
                            }.padding(15)
                            
                            Button {
                                selectedImageIndex += 1
                            } label: {
                                Image(systemName: "hand.thumbsdown.circle").resizable().frame(width: 70, height: 70)
                                    .foregroundColor(Color.black)
                            }.padding(15)
                        }
                    }
                    
                    if !showNextButton {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(information[selectedImageIndex][2])
                                .padding(.bottom, 15)
                        }
                        .padding()
                        HStack {
                            VStack {
                                NavigationLink(destination: PlantConditionView(mainImage: mainImage,model_diagnose: model_diagnose)
                                    .navigationBarBackButtonHidden(true),
                                               label: {
                                    Image(systemName: "humidity")
                                        .frame(width: 119,
                                               height: 46)
                                        .background(Color.black)
                                        .cornerRadius(6)
                                        .foregroundColor(Color.white)
                                })
                                Text("Diagnose")
                            }
                            .padding(.horizontal, 20)
                            
                            VStack {
                                NavigationLink(destination: PlantConditionView(mainImage: mainImage).navigationBarBackButtonHidden(true),
                                               label: {
                                    Image(systemName: "info.circle")
                                        .frame(width: 119,
                                               height: 46)
                                        .background(Color.black)
                                        .cornerRadius(6)
                                        .foregroundColor(Color.white)
                                })
                                Text("Details")
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct plantView_Previews: PreviewProvider {
    static var previews: some View {
        PlantView(mainImage: UIImage(imageLiteralResourceName: "homeimage"))
    }
}
