//
//  Exercise.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 13/06/24.
//

import Foundation


struct Exercise: Codable {
    let name: String
    let force: String?
    let level: String?
    let mechanic: String?
    let equipment: String?
    let primaryMuscles: [String]?
    let secondaryMuscles: [String]?
    let instructions: [String]?
    let category: String?
    let images: [String]?
    let id: String
}

class ExerciseViewModel: ObservableObject {
    
    @Published var exercise: [Exercise] = []
    @Published var searchText: String = ""
    
    init() {
        loadExercise()
    }
    
    func loadExercise() {
        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            exercise = try JSONDecoder().decode([Exercise].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    var filteredMeals: [Exercise] {
        if searchText.isEmpty {
            return exercise
        } else {
            return exercise.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
