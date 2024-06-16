//
//  PlantIdentifier.swift
//  DrPlant
//
//  Created by Alisa Pogodaeva on 16.06.24.
//
import SwiftUI
import Foundation
import Combine



class PlantIdentifier: ObservableObject {
    @Published var suggestions: [PlantSuggestion] = []
    @Published var isLoading = false
    
    func uploadImage(uiImage: UIImage) {
        guard let base64Image = imageToBase64(image: uiImage) else {
            print("Error converting image to base64.")
            return
        }

        isLoading = true // Start loading
        
        let apiKey = "vv5xvG5VqtMlSqBRRV7F0lSIfXYOwu54l5Zl2Hno4nDY2NVus5"
        guard let url = URL(string: "https://plant.id/api/v3/identification") else {
            print("Invalid URL")
            return
        }
        
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

        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Error creating JSON data")
            return
        }
        
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false // Stop loading
                }
            }
            
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let plantResponse = try decoder.decode(PlantResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.suggestions = plantResponse.result.classification.suggestions.map { suggestion in
                        let plantSimilarImages = suggestion.similarImages?.compactMap { similarImage in
                            guard let url = URL(string: similarImage.url),
                                  let smallUrl = URL(string: similarImage.url_small) else {
                                return nil
                            }
                            return PlantSimilarImage(id: similarImage.id, url: url, similarity: similarImage.similarity, urlSmall: smallUrl)
                        } ?? []
                        
                        return PlantSuggestion(name: suggestion.name,
                                               probability: suggestion.probability,
                                               similarImages: plantSimilarImages)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }
    
    func imageToBase64(image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1.0)?.base64EncodedString()
    }
}
