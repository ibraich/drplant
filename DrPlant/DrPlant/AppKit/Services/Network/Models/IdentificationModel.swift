//
//  IdentificationModel.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation

struct IdentificationModel: Codable, Hashable, Equatable {
    let accessToken: String
    let result: Result
    
    struct Result: Codable, Hashable, Equatable {
        let classification: Classification

        struct Classification: Codable, Hashable, Equatable {
            let suggestions: [Suggestion]

            struct Suggestion: Codable, Hashable, Equatable {
                let name: String
                let probability: Double
                let similarImages: [SimilarImage]

                enum CodingKeys: String, CodingKey {
                    case name, probability
                    case similarImages = "similar_images"
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
            }
        }
    }
    enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case result
        }
}
