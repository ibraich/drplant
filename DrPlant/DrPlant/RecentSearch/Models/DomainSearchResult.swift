//
//  DomainSearchResult.swift
//  DrPlant
//
//  Created by Dzmitry Semianovich on 13/07/2024.
//

import SwiftUI

struct DomainSearchResult: Hashable, Equatable {
    let image: UIImage?
    var modelDiagnose: HealthAssessmentModel?
    var identificationResult: IdentificationModel?
}
