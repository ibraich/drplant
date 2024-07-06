//
//  HealthRequestManager.swift
//  DrPlant
//
//  Created by Ibrahım Erdogan on 1.07.2024.
//

import Foundation

class HealthAssessmentRequestManager {
    let network: NetworkManagerProtocol = NetworkManager.shared
}

extension HealthAssessmentRequestManager {
    func healthAssessment(endPoint: EndPoints, completion: @escaping (Result<HealthAssessmentModel, Error>) -> Void) {
        network.makeRequest(endPoint: endPoint, completion: completion)
        
    }
}
