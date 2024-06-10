//
//  HomeView.swift
//  DrPlant
//
//  Created by Adam Bokun on 1.06.24.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var mainImage: UIImage?
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingCamera = false
    @State private var isPhotoPicked = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("DrPlant")
                Spacer()
                Image(uiImage: mainImage ?? UIImage(imageLiteralResourceName: "homeimage"))
                    .resizable()
                    .frame(width: 343,
                           height: 360)
                HStack {
                    VStack {
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            Image(systemName: "arrow.up")
                                .frame(width: 119,
                                       height: 46)
                                .background(Color.black)
                                .cornerRadius(6)
                                .foregroundColor(Color.white)
                        }
                        Text("Upload")
                    }
                    .onChange(of: photosPickerItem) { newItem in
                        if let newItem = newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                    isPhotoPicked = true
                                }
                            }
                        }
                    }
                    .padding(20)
                    
                    VStack {
                        Button(action: {
                            isShowingCamera = true
                        }) {
                            Image(systemName: "camera")
                                .frame(width: 119,
                                       height: 46)
                                .background(Color.black)
                                .cornerRadius(6)
                                .foregroundColor(Color.white)
                        }
                        Text("Take a pic")
                    }
                    .padding(20)
                    
                }
                NavigationLink(destination: PlantView().navigationBarBackButtonHidden(true),
                               isActive: $isPhotoPicked) {
                    EmptyView()
                }
                Spacer()
            }.fullScreenCover(isPresented: $isShowingCamera) {
                CameraPickerView() { image in
                    //
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
