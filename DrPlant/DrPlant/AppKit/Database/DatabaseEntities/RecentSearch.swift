//
//  RecentSearch.swift
//  DrPlant
//
//  Created by Dzmitry Semianovich on 13/07/2024.
//

@preconcurrency import RealmSwift
import SwiftUI

final class RecentSearch: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var image: Data?
    @Persisted var diagnoseJson: String?
    @Persisted var identificationJson: String?
    
    convenience init(
        image: UIImage,
        model_diagnose: HealthAssessmentModel,
        model: IdentificationModel
    ) {
        self.init()
        self.id = UUID().uuidString
        
        self.image = image.jpegData(compressionQuality: 1.0)
        
        let jsonEncoder = JSONEncoder()
        do {
            let diagnoseJsonData = try jsonEncoder.encode(model_diagnose)
            let diagnoseJson = String(data: diagnoseJsonData, encoding: String.Encoding.utf8)
            self.diagnoseJson = diagnoseJson
            
            let identificationJsonData = try jsonEncoder.encode(model)
            let identificationJson = String(data: identificationJsonData, encoding: String.Encoding.utf8)
            self.identificationJson = identificationJson
        } catch {
            print(error.localizedDescription)
        }
    }
}
