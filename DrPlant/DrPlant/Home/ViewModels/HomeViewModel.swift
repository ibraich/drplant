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
    @Published var images_diagnose = [""]
    @Published var similar_images = true
    @Published var model_diagnose: HealthAssessmentModel?
    @Published var model: IdentificationModel?
    @Published var showPlantView: Bool = false
    
    var requestManager: RequestManager
    var healthAssessmentRequestManager:HealthAssessmentRequestManager
    init(requestManager: RequestManager,healthAssessmentRequestManager: HealthAssessmentRequestManager) {
        self.requestManager = requestManager
        self.healthAssessmentRequestManager = healthAssessmentRequestManager
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
        healthAssessmentRequestManager.healthAssessment(endPoint: .healthAssessment(images: images, similar_images: similar_images)) { response in
                switch response {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.model_diagnose = result
                        // Handle showing or processing the health assessment result as needed
                    }
                    print(result)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    print(error)
                }
            }
        print("model diagnose")
        print(model_diagnose?.result.disease.suggestions[0].name ?? "")
    }
}
