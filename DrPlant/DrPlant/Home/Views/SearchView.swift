import SwiftUI

struct PlantDetail: Identifiable {
    let id = UUID()
    let name: String
    let description: String?
    let imageUrl: String?
    let taxonomy: Taxonomy
    let edibleParts: [String]?
}

struct Taxonomy: Identifiable {
    let id = UUID()
    let plantClass: String
    let genus: String
    let order: String
    let family: String
    let phylum: String
    let kingdom: String
    let species: String?
}

struct Plant: Identifiable {
    let id = UUID()
    let entityName: String
    let accessToken: String
}

struct SearchView: View {
    @State private var plantName: String = ""
    @State private var plants: [Plant] = []
    @State private var selectedPlantDetail: PlantDetail? = nil
    @State private var isDetailViewActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                if !isDetailViewActive {
                    VStack(spacing: 10) {
                        TextField("Enter plant name", text: $plantName)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            searchPlant()
                        }) {
                            Text("Search")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 5)
                        
                        List(plants) { plant in
                            Button(action: {
                                fetchPlantDetails(accessToken: plant.accessToken)
                            }) {
                                Text(plant.entityName)
                            }
                        }
                    }
                    .padding()
                } else {
                    VStack(spacing: 10) {
                        HStack {
                            Button(action: {
                                isDetailViewActive = false
                            }) {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Back")
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                            Spacer()
                        }
                        ScrollView {
                            VStack(spacing: 10) {
                                if let plantDetail = selectedPlantDetail {
                                    if let imageUrl = plantDetail.imageUrl, let url = URL(string: imageUrl),
                                       let imageData = try? Data(contentsOf: url),
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 300, height: 300)
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 300, height: 300)
                                            .foregroundColor(.gray)
                                    }
                                    Text(plantDetail.name)
                                        .font(.title)
                                        .padding(.top, 10)
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Taxonomy")
                                            .font(.headline)
                                            .padding(.top)
                                        Text("Class: \(plantDetail.taxonomy.plantClass)")
                                        Text("Genus: \(plantDetail.taxonomy.genus)")
                                        Text("Order: \(plantDetail.taxonomy.order)")
                                        Text("Family: \(plantDetail.taxonomy.family)")
                                        Text("Phylum: \(plantDetail.taxonomy.phylum)")
                                        Text("Kingdom: \(plantDetail.taxonomy.kingdom)")
                                        if let species = plantDetail.taxonomy.species {
                                            Text("Species: \(species)")
                                        }
                                    }
                                    .padding(.horizontal)
                                    if let description = plantDetail.description {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Description")
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                                .padding(.top, 20) // Add space before "Description"
                                            Text(description)
                                        }
                                        .padding(.horizontal)
                                    }
                                    if let edibleParts = plantDetail.edibleParts {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Edible Parts")
                                                .font(.headline)
                                                .padding(.top)
                                            ForEach(edibleParts, id: \.self) { part in
                                                Text(part)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    .navigationBarTitle("Plant Details", displayMode: .inline)
                    .padding()
                }
            }
        }
    }
    
    func searchPlant() {
        guard let encodedPlantName = plantName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let url = URL(string: "https://plant.id/api/v3/kb/plants/name_search?q=\(encodedPlantName)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("bV3kX21qoaKLx0qWhWFqha3aMmtD6T7sXbB7D78yQ7v92XydEG", forHTTPHeaderField: "Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Search Response: \(responseString)")
                    }
                    if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let entitiesArray = responseDict["entities"] as? [[String: Any]] {
                        DispatchQueue.main.async {
                            plants = entitiesArray.compactMap { entityDict in
                                if let entityName = entityDict["entity_name"] as? String,
                                   let accessToken = entityDict["access_token"] as? String {
                                    print("Received Access Token: \(accessToken) for Plant: \(entityName)")
                                    return Plant(entityName: entityName, accessToken: accessToken)
                                }
                                return nil
                            }
                        }
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            } else if let error = error {
                print("Error performing request: \(error)")
            }
        }.resume()
    }
    
    func fetchPlantDetails(accessToken: String) {
        let url = URL(string: "https://plant.id/api/v3/kb/plants/\(accessToken)?details=common_names%2Curl%2Cdescription%2Ctaxonomy%2Crank%2Cgbif_id%2Cinaturalist_id%2Cimage%2Csynonyms%2Cedible_parts%2Cwatering%2Cpropagation_methods&lang=en")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("TzmkUH1lVPNVqK7YTNHBk8xER0tL9VquupWB4MK2I1SM3vQB6r", forHTTPHeaderField: "Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Plant Details Response: \(responseString)")
                    }
                    if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let name = responseDict["name"] as? String,
                       let description = (responseDict["description"] as? [String: Any])?["value"] as? String?,
                       let imageUrl = (responseDict["image"] as? [String: Any])?["value"] as? String?,
                       let taxonomyDict = responseDict["taxonomy"] as? [String: Any],
                       let plantClass = taxonomyDict["class"] as? String,
                       let genus = taxonomyDict["genus"] as? String,
                       let order = taxonomyDict["order"] as? String,
                       let family = taxonomyDict["family"] as? String,
                       let phylum = taxonomyDict["phylum"] as? String,
                       let kingdom = taxonomyDict["kingdom"] as? String {
                        let species = taxonomyDict["species"] as? String
                        let edibleParts = responseDict["edible_parts"] as? [String]
                        let taxonomy = Taxonomy(plantClass: plantClass, genus: genus, order: order, family: family, phylum: phylum, kingdom: kingdom, species: species)
                        let plantDetail = PlantDetail(name: name, description: description, imageUrl: imageUrl, taxonomy: taxonomy, edibleParts: edibleParts)
                        DispatchQueue.main.async {
                            selectedPlantDetail = plantDetail
                            isDetailViewActive = true
                        }
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            } else if let error = error {
                print("Error performing request: \(error)")
            }
        }.resume()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
