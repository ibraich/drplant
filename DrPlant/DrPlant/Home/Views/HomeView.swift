import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var mainImage: UIImage?
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingCamera = false
    @State private var isPhotoPicked = false
    @State private var plantName: String = ""
    @State private var probability: Double = 0.0
    @State private var similarImages: [String] = []
    @State private var suggestions: [PlantSuggestion] = []


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
                    .onChange(of: photosPickerItem) { newItem in
                        if let newItem = newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                    isPhotoPicked = true
                                    uploadImage(uiImage: uiImage)
                                    //parsePlantResponse()
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
                                .frame(width: 119, height: 46)
                                .background(Color.black)
                                .cornerRadius(6)
                                .foregroundColor(Color.white)
                        }
                        Text("Take a pic")
                    }
                    .padding(20)
                    
                }
                NavigationLink(destination: PlantView().navigationBarBackButtonHidden(true), isActive: $isPhotoPicked) {
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
        
    
    
    
    // Function to convert UIImage to Base64
    func imageToBase64(image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1.0)?.base64EncodedString()
    }

    // Function to upload the image
    func uploadImage(uiImage: UIImage) {
            guard let base64Image = imageToBase64(image: uiImage) else {
                print("Error converting image to base64.")
                return
            }

            let apiKey = "vv5xvG5VqtMlSqBRRV7F0lSIfXYOwu54l5Zl2Hno4nDY2NVus5"
            let url = URL(string: "https://plant.id/api/v3/identification")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let json: [String: Any] = [
                "images": ["data:image/jpg;base64,\(base64Image)"],
                "latitude": 49.207,
                "longitude": 16.608,
                "similar_images": true
            ]

            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData

            print("Request: \(String(describing: request))")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                if let response = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(response.statusCode)")
                }

                if let data = data {
                    print("Raw Response Data: \(String(describing: String(data: data, encoding: .utf8)))")
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(PlantResponse.self, from: data)

                        DispatchQueue.main.async {
                            self.suggestions = response.result.classification.suggestions.map {
                                PlantSuggestion(
                                    name: $0.name,
                                    probability: $0.probability,
                                    similarImages: $0.similarImages.map { $0.url }
                                )
                            }

                            // Print all suggestions
                            self.printSuggestions()
                        }
                    } catch {
                        print("Error parsing response: \(error)")
                    }
                }
            }

            task.resume()
        }

        // Function to print all suggestions
        func printSuggestions() {
            for suggestion in suggestions {
                print("Plant Name: \(suggestion.name)")
                print("Probability: \(suggestion.probability)")
                print("Similar Images: \(suggestion.similarImages)")
                print("---")
            }
        }
    }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
