//
//  People.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 16/05/24.
//

import Foundation
struct People: Codable, Identifiable, Hashable {
    let id: Int
    let username: String
    let profileImage: String
    let mainImage: String
    var isLiked: Bool
}

class PeopleViewModel: ObservableObject {
    @Published var people: [People] = []
    
    init() {
        loadPeople()
    }
    
    func loadPeople() {
        guard let url = Bundle.main.url(forResource: "people", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            people = try JSONDecoder().decode([People].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
}

