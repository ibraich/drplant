//
//  EndPoints.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation

enum EndPoints {
    case recognition(images: [String], similar_images: Bool)
}

extension EndPoints {
    var baseUrl: String {
        switch self {
        case .recognition:
            return "https://plant.id/api/v3/identification"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .recognition:
            return .post
        }
    }
    
    var body: [String: Any] {
        switch self {
        case .recognition(let images, let similar_images):
            return ["images": images,
                    "similar_images": true]
        }
    }
}
