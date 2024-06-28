//
//  HomeViewModel.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var showHomeView = false
    @Published var isLoading = false
    
    @Published var images = [""]
    @Published var similar_images = true
    @Published var model: IdentificationModel?
    @Published var showPlantView: Bool = false
    
    var requestManager: RequestManager
    
    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }
    
    func uploadButtonTapped() {
        isLoading = true
        requestManager.recognition(endPoint: .recognition(images: images, similar_images: similar_images)) { response in
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.model = result
                    self.showPlantView = true
                }
                print(result)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
        print(model?.result.classification.suggestions[0].name ?? "")
    }
}
