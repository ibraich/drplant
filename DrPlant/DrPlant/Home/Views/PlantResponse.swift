struct PlantResponse: Codable {
    let result: Result

    struct Result: Codable {
        let classification: Classification

        struct Classification: Codable {
            let suggestions: [Suggestion]

            struct Suggestion: Codable {
                let name: String
                let probability: Double
                let similarImages: [SimilarImage]

                enum CodingKeys: String, CodingKey {
                    case name, probability
                    case similarImages = "similar_images"
                }

                struct SimilarImage: Codable {
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
}

struct PlantSuggestion {
    let name: String
    let probability: Double
    let similarImages: [String]
}
