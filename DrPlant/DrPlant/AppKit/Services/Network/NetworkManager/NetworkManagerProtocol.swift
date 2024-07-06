//
//  NetworkManagerProtocol.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation

protocol NetworkManagerProtocol {
    typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    func cancel ()
    func makeRequest<T: Codable>(endPoint: EndPoints, completion: @escaping (Result<T, Error>) -> Void)
}
