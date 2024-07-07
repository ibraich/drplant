//
//  NetworkManager.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum APIError: Error {
    case invalidURL
    case networkError
    case invalidResponse
}

private enum NetworkResponse: Error, LocalizedError {
    case success
    case failed
    case noData
    case unableToDecode
    case custom(error: String)
    
    var errorDescription: String? {
        switch self {
        case .success:
            return "Scucces"
        case .failed:
            return "Failed"
        case .noData:
            return "No data"
        case .unableToDecode:
            return "Unable to decode"
        case .custom(let error):
            return error
        }
    }
}

public class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    var task: URLSessionTask?
    
    private func request (endPoint: EndPoints, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            guard let request = try buildRequest(endPoint)
            else {
                completion(nil, nil, APIError.invalidURL)
                return
            }
            
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
            
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    public func cancel () {
        task?.cancel()
    }
    
    private func buildRequest(_ endPoint: EndPoints) throws -> URLRequest? {
        
        guard let requestUrl = URL(string: endPoint.baseUrl)
        else { return nil }
        
        var request = URLRequest(url: requestUrl,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
        
        let tokenID = "TzmkUH1lVPNVqK7YTNHBk8xER0tL9VquupWB4MK2I1SM3vQB6r"
        request.httpMethod = endPoint.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch endPoint.httpMethod {
        case .post:
            do {
                request.setValue(tokenID, forHTTPHeaderField: "Api-Key")
                request.httpBody = try JSONSerialization.data(withJSONObject: endPoint.body,
                                                              options: .prettyPrinted)
            } catch (let error) {
                print(error)
                return nil
            }
        case .get:
            request.setValue(tokenID, forHTTPHeaderField: "Api-Key")
        }
        return request
    }
    
    func makeRequest<T: Codable>(endPoint: EndPoints, completion: @escaping (Result<T, Error>) -> Void) {
        request(endPoint: endPoint) { data, response, error in
            if error != nil {
                completion(.failure(NetworkResponse.failed))
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    guard let responseData = data else {
                        completion(.failure(NetworkResponse.noData))
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                        print(response.description)
                        print(response.statusCode)
                        completion(.success(apiResponse))
                    } catch let error {
                        print(error.localizedDescription)
                        print(String(describing: error))
                        completion(.failure(NetworkResponse.unableToDecode))
                    }
                default:
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                        let jsonString = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        let string = String(data: jsonString, encoding: .utf8)
                        print(string ?? "")
                        let apiResponse = try? JSONDecoder().decode(ErrorDetailModel.self, from: data!)
                        completion(.failure(apiResponse != nil ? NetworkResponse.custom(error: apiResponse?.detail ?? "") : NetworkResponse.unableToDecode))
                    } catch {
                    }
                    print(response.description)
                    print(response.statusCode)
                    completion(.failure(NetworkResponse.failed))
                }
            }
        }
    }
}
