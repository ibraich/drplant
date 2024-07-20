//
//  PlantInfo.swift
//  DrPlant
//
//  Created by Dzmitry Semianovich on 13/07/2024.
//

import Foundation

struct PlantInfo {
    let name: String
    let probability: Double
    let imageURL: URL // Store image URL
    let localName: String
    let description: String
    let chemical: [String]?
    let biological: [String]?
    let prevention: [String]?
    init(name: String, probability: Double, imageURL: URL, localName: String, description: String,chemical: [String]?, biological: [String]?, prevention: [String]?) {
        self.name = name
        self.probability = probability
        self.imageURL = imageURL
        self.localName = localName
        self.description = description
        self.chemical = chemical
        self.biological = biological
        self.prevention = prevention
    }
}
