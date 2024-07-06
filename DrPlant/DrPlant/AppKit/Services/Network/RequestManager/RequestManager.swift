//
//  RequestManager.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation

class RequestManager {
    let network: NetworkManagerProtocol = NetworkManager.shared
}

extension RequestManager {
    func recognition(endPoint: EndPoints, completion: @escaping (Result<IdentificationModel, Error>) -> Void) {
        network.makeRequest(endPoint: endPoint, completion: completion)
    }
}
