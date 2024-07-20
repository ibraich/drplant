//
//  RecentSearchViewModel.swift
//  DrPlant
//
//  Created by Dzmitry Semianovich on 13/07/2024.
//

import SwiftUI

final class RecentSearchViewModel: ObservableObject {
    
    // MARK: - Public properties
    
    @Published var searchResults = [DomainSearchResult]()
    
    // MARK: - Private properties
    
    private let database = Services.database
    
    // MARK: - Initialisation
    
    init() {
        initSearchResults()
    }
    
    // MARK: - Public methods
    
    func initSearchResults() {
        guard let entities = database.objects(RecentSearch.self) else {
            return
        }
        
        searchResults = Array(entities).compactMap { entity -> DomainSearchResult? in
            guard let diagnoseData = entity.diagnoseJson?.data(using: .utf8),
                  let identificationData = entity.identificationJson?.data(using: .utf8) else {
                return nil
            }

            let jsonDecoder = JSONDecoder()
            
            do {
                let diagnose = try jsonDecoder.decode(
                    HealthAssessmentModel.self,
                    from: diagnoseData
                )
                let identificationResult = try jsonDecoder.decode(
                    IdentificationModel.self,
                    from: identificationData
                )
                
                return DomainSearchResult(
                    image: entity.image == nil ? nil : UIImage(data: entity.image ?? .init()),
                    modelDiagnose: diagnose,
                    identificationResult: identificationResult
                )
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
}
