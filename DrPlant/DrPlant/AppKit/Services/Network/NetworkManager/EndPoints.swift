//
//  EndPoints.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation

enum EndPoints {
    case recognition(images: [String], similar_images: Bool)
    case healthAssessment(images: [String], similar_images: Bool)
}

extension EndPoints {
    var baseUrl: String {
        switch self {
        case .recognition:
            return "https://plant.id/api/v3/identification"
        case .healthAssessment:
            return "https://plant.id/api/v3/health_assessment?details=local_name,description,treatment"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .recognition, .healthAssessment:
            return .post
        }
    }
    
    var body: [String: Any] {
        switch self {
        case .recognition(let images, let similar_images):
            return ["images": images,
                    "similar_images": similar_images]
        case .healthAssessment(let images, let similar_images):
            return ["images": images,
                    "similar_images": similar_images,
                                                    ]
        }
    }
}
