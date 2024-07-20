//
//  RecentSearchView.swift
//  DrPlant
//
//  Created by Dzmitry Semianovich on 13/07/2024.
//

import SwiftUI

struct RecentSearchView: View {
    
    @StateObject private var viewModel = RecentSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("DrPlant")
                
                Spacer()
                
                switch viewModel.searchResults.count {
                case 0:
                    Text("Sorry :(\nThere's no search results yet..")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                default :
                    List {
                        ForEach(viewModel.searchResults, id: \.self) { result in
                            NavigationLink(value: result) {
                                searchItem(result)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(
                                top: 8,
                                leading: 16,
                                bottom: 8,
                                trailing: 16
                            ))
                        }
                    }
                    .listStyle(.plain)
                }
                
                Spacer()
            }
            .navigationDestination(for: DomainSearchResult.self) { searchResult in
                PlantView(
                    viewModel: .init(
                        mainImage: searchResult.image,
                        model: searchResult.identificationResult,
                        model_diagnose: searchResult.modelDiagnose
                    )
                )
            }
            .onAppear {
                viewModel.initSearchResults()
            }
        }
    }
    
    @ViewBuilder
    private func searchItem(_ item: DomainSearchResult) -> some View {
        if let image = item.image,
           let name = item.identificationResult?.result.classification.suggestions.first?.name {
            
            HStack(spacing: 12) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack {
                    Text(name)
                        .font(.title3)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}
