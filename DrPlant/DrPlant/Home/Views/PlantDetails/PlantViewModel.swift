//
//  PlantViewModel.swift
//  DrPlant
//
//  Created by Dzmitry Semianovich on 13/07/2024.
//

import Foundation
import SwiftUI

final class PlantViewModel: ObservableObject {
    typealias ClassificationSuggestion = IdentificationModel.Result.Classification.Suggestion
    
    // MARK: - Public properties
    
    let mainImage: UIImage?
    var model_diagnose: HealthAssessmentModel?
    var model: IdentificationModel?
    
    var displayImage: Image {
        Image(uiImage: mainImage ?? UIImage(imageLiteralResourceName: "homeimage"))
    }
    
    var suggestedImageUrls: [URL] {
        model?.result.classification.suggestions.flatMap {
            $0.similarImages
        }.compactMap {
            URL(string: $0.url)
        } ?? []
    }
    
    var suggestions: [ClassificationSuggestion] {
        model?.result.classification.suggestions ?? []
    }
    
    // MARK: - Initialisation
    
    init(
        mainImage: UIImage?,
        model: IdentificationModel? = nil,
        model_diagnose: HealthAssessmentModel? = nil
    ) {
        self.mainImage = mainImage
        self.model = model
        self.model_diagnose = model_diagnose
    }
}
