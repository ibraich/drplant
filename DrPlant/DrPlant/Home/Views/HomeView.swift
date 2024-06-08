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
    @State private var isShowingCamera = false
    
    var body: some View {
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
            Spacer()
        }.fullScreenCover(isPresented: $isShowingCamera) {
            CameraPickerView() { image in
                    //
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
