//
//  PlantView.swift
//  DrPlant
//
//  Created by Adam Bokun on 10.06.24.
//

import SwiftUI
import Kingfisher

struct PlantView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: PlantViewModel
    
    @State private var selectedImageIndex = 0
    @State private var showNextButton = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    Text("DrPlant")
                        .padding(.bottom, 5)
                    
                    Spacer()
                    
                    viewModel.displayImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    if showNextButton {
                        ZStack(alignment: .center) {
                            ForEach(viewModel.suggestedImageUrls.indices) { idx in
                                KFImage(viewModel.suggestedImageUrls[idx])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 10)
                                    .offset(x: CGFloat(idx - selectedImageIndex) * 220)
                                    .animation(.easeInOut, value: selectedImageIndex)
                            }
                        }
                        .frame(height: 200)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < -50 {
                                        if (selectedImageIndex + 1) < viewModel.suggestions.count {
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
                    } else {
                        KFImage(viewModel.suggestedImageUrls[selectedImageIndex])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
                    }
                    
                    if showNextButton {
                        Text("Does your plant look like\n" +  viewModel.suggestions[selectedImageIndex].name + "?").font(.title3)
                            .padding(.bottom, 5)
                    }
                    
                    if showNextButton {
                        HStack {
                            Button {
                                showNextButton.toggle()
                            } label: {
                                Image(systemName: "hand.thumbsup.circle").resizable().frame(width: 70, height: 70)
                                    .foregroundColor(Color.black)
                            }.padding(15)
                            
                            Button {
                                if (selectedImageIndex + 1) < viewModel.suggestions.count {
                                    selectedImageIndex += 1
                                }
                            } label: {
                                Image(systemName: "hand.thumbsdown.circle").resizable().frame(width: 70, height: 70)
                                    .foregroundColor(Color.black)
                            }.padding(15)
                        }
                    }
                    
                    if !showNextButton {
                        HStack {
                            Spacer()
                            Text(viewModel.suggestions[selectedImageIndex].name).font(.title)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        VStack(alignment: .center, spacing: 10) {
                            Text("Here you can diagnoze your plant or ask a chatbot for care recomendations")
                                .padding(.bottom, 15)
                        }
                        .padding()
                        
                        HStack {
                            VStack {
                                NavigationLink(destination: PlantConditionView(
                                    mainImage: viewModel.mainImage,
                                    model_diagnose: viewModel.model_diagnose
                                ),
                                               label: {
                                    Image(systemName: "humidity")
                                        .frame(width: 100,
                                               height: 46)
                                        .background(Color.black)
                                        .cornerRadius(6)
                                        .foregroundColor(Color.white)
                                })
                                Text("Diagnose")
                            }
                            .padding(.horizontal, 10)
                            
                            VStack {
                                NavigationLink(destination: ChatBotView(model: viewModel.model),
                                               label: {
                                    Image(systemName: "person")
                                        .frame(width: 100,
                                               height: 46)
                                        .background(Color.black)
                                        .cornerRadius(6)
                                        .foregroundColor(Color.white)
                                })
                                Text("ChatBot")
                            }
                            .padding(.horizontal, 10)
                        }
                        
                        Spacer()
                        
                        Button {
                            showNextButton = true
                        } label: {
                            Text("I am not sure this is my plant").foregroundColor(Color.blue).underline().font(.system(size: 12))
                        }
                        
                    }
                }
                
                Spacer()
                    .padding(.horizontal)
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    })
                }
            })
        }
        .toolbar(.hidden)
    }
}
