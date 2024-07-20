//
//  HomeViewModel.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    // MARK: - Public properties
    
    @Published var showHomeView = false
    @Published var isLoading = false
    
    @Published var images = [""]
    @Published var images_diagnose = [""]
    @Published var similar_images = true
    @Published var model_diagnose: HealthAssessmentModel?
    @Published var model: IdentificationModel?
    @Published var showPlantView: Bool = false
    
    // MARK: - Private properties
    
    private var requestManager: RequestManager
    private var healthAssessmentRequestManager: HealthAssessmentRequestManager
    private let database = Services.database
    
    private let group = DispatchGroup()
    
    // MARK: - Initialisation
    
    init(
        requestManager: RequestManager,
        healthAssessmentRequestManager: HealthAssessmentRequestManager
    ) {
        self.requestManager = requestManager
        self.healthAssessmentRequestManager = healthAssessmentRequestManager
    }
    
    // MARK: - Public methods
    
    func uploadButtonTapped(_ image: UIImage) {
        isLoading = true
        
        group.enter()
        requestManager.recognition(
            endPoint: .recognition(
                images: images,
                similar_images: similar_images
            )
        ) { [weak self] response in
            guard let self else {
                return
            }
            
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    self.model = result
                }
                print(result)
                group.leave()
            case .failure(let error):
                print(error)
                group.leave()
            }
        }
        
        group.enter()
        healthAssessmentRequestManager.healthAssessment(
            endPoint: .healthAssessment(
                images: images,
                similar_images: similar_images
            )
        ) { [weak self] response in
            guard let self else {
                return
            }
                switch response {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.model_diagnose = result
                        // Handle showing or processing the health assessment result as needed
                    }
                    print(result)
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
        print("model diagnose")
        print(model_diagnose?.result.disease.suggestions[0].name ?? "")
        
        group.notify(queue: .main) {
            self.storeSearchResults(for: image)
            self.isLoading = false
            self.showPlantView = true
        }
    }
    
    private func storeSearchResults(for image: UIImage) {
        guard let model,
              let model_diagnose else {
            return
        }
        
        let entity = RecentSearch(
            image: image,
            model_diagnose: model_diagnose,
            model: model
        )
        
        database.add([entity])
    }
}
