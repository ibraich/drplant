import SwiftUI
import PhotosUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel(
        requestManager: RequestManager(),
        healthAssessmentRequestManager: HealthAssessmentRequestManager()
    )
    
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var mainImage: UIImage?
    @State private var uploadedImage: UIImage?
    @State private var selectedImage: Image? = nil
    @State private var isShowingCamera = false
    @State private var isPhotoPicked = false
    @State private var plantName: String = ""
    @State private var probability: Double = 0.0
    @State private var similarImages: [String] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("DrPlant")
                Spacer()
                
                Image(uiImage: mainImage ?? UIImage(imageLiteralResourceName: "homeimage"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 343, height: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                
                HStack {
                    VStack {
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            Image(systemName: "arrow.up")
                                .frame(width: 119, height: 46)
                                .background(Color.black)
                                .cornerRadius(6)
                                .foregroundColor(Color.white)
                        }
                        Text("Upload")
                    }
                    .task(id: photosPickerItem) {
                        do {
                            
                            if let image = try await photosPickerItem?.getImage(),
                               case let.success(uiImage) = image {
                                mainImage = uiImage
                                homeViewModel.images = ImageConvertor.convertImageToBase64Strings(image: uiImage)
                                homeViewModel.uploadButtonTapped(uiImage)
                                photosPickerItem = nil
                            }
                            
                            
                        } catch {
                            print("Error loading transferable image: \(error.localizedDescription)")
                        }
                    }
                    .padding(20)
                    
                    VStack {
                        Button(action: {
                            isShowingCamera = true
                        }) {
                            Image(systemName: "camera")
                                .frame(width: 119, height: 46)
                                .background(Color.black)
                                .cornerRadius(6)
                                .foregroundColor(Color.white)
                        }
                        Text("Take a pic")
                    }
                    .padding(20)
                    
                }
                
                if homeViewModel.isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        
                        Text("Processing ur picture...")
                    }
                }
                
                Spacer()
            }
            .navigationDestination(isPresented: $homeViewModel.showPlantView) {
                PlantView(
                    viewModel: .init(
                        mainImage: mainImage,
                        model: homeViewModel.model,
                        model_diagnose: homeViewModel.model_diagnose
                    )
                )
            }
        }.fullScreenCover(isPresented: $isShowingCamera) {
            CameraPickerView() { image in
                mainImage = image
                homeViewModel.images = ImageConvertor.convertImageToBase64Strings(image: image)
                homeViewModel.uploadButtonTapped(image)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
