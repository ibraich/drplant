import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var mainImage: UIImage?
    @State private var uploadedImage: UIImage?
    @State private var selectedImage: Image? = nil
    @State private var isShowingCamera = false
    @State private var isPhotoPicked = false
    @State private var plantName: String = ""
    @State private var probability: Double = 0.0
    @State private var similarImages: [String] = []
    @StateObject var homeViewModel = HomeViewModel(requestManager: RequestManager(),healthAssessmentRequestManager: HealthAssessmentRequestManager())
    
    var body: some View {
        NavigationView {
            VStack {
                Text("DrPlant")
                Spacer()
                Image(uiImage: mainImage ?? UIImage(imageLiteralResourceName: "homeimage"))
                    .resizable()
                    .frame(width: 343, height: 360)
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
                                print("")
                                mainImage = uiImage
                                homeViewModel.images = ImageConvertor.convertImageToBase64Strings(image: uiImage)
                                homeViewModel.uploadButtonTapped()
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
                NavigationLink(destination: PlantView(mainImage: mainImage, model: homeViewModel.model,model_diagnose:homeViewModel.model_diagnose).navigationBarBackButtonHidden(true), isActive: $homeViewModel.showPlantView) {
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

extension PhotosPickerItem{
    func getImage() async throws -> Result<UIImage, Error>{
        let data = try await self.loadTransferable(type: Data.self)
        guard let data = data, let image = UIImage(data: data) else{
            return .failure(AppError.noImageFound)
        }
        return .success(image)
    }
    
}

enum AppError: LocalizedError{
    case noImageFound
}
