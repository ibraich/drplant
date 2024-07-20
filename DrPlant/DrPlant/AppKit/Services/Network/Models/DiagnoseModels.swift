//
//  DiagnoseModels.swift
//  DrPlant
//
//  Created by Ibrahım Erdogan on 1.07.2024.
//

import Foundation
struct HealthAssessmentModel: Codable, Hashable, Equatable {
    let accessToken: String
    let result: Result
    
    struct Result: Codable, Hashable, Equatable {
        let disease: Disease
        
        struct Disease: Codable, Hashable, Equatable {
            let suggestions: [Suggestion]
            
            struct Suggestion: Codable, Hashable, Equatable {
                let name: String
                let probability: Double
                let similarImages: [SimilarImage]
                let details: Details
                
                
                enum CodingKeys: String, CodingKey {
                    case name, probability
                    case similarImages = "similar_images"
                    case details
                    
                }
                
                struct SimilarImage: Codable, Hashable, Equatable {
                    let id: String
                    let similarity: Double
                    let url: String
                    let urlSmall: String
                    
                    enum CodingKeys: String, CodingKey {
                        case id, similarity, url
                        case urlSmall = "url_small"
                    }
                }
                
                struct Details: Codable, Hashable, Equatable{
                    let localName : String
                    let description : String
                    let treatment : Treatment
                    
                    enum CodingKeys: String, CodingKey {
                        case localName = "local_name"
                        case description
                        case treatment
                    }
                    
                    struct Treatment: Codable, Hashable, Equatable {
                        let chemical : [String]?
                        let biological : [String]?
                        let prevention : [String]?
                        
                        enum CodingKeys: String, CodingKey {
                            case chemical, biological, prevention
                        }
                    }
                }
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case result
    }
}
