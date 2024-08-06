//
//  MealCSV.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 13/06/24.


import Foundation

struct MealCSV: Codable {
    let id: Int
    let name: String
    let calories: Int?
    let protein: Double?
    let carbohydrate: Double?
    let fattyAcidsSaturated: Double?
    let cholestrol: Double?
    let weight: Double?
}

class MealCSVViewModel: ObservableObject {
    @Published var meals: [MealCSV] = []
    @Published var searchText: String = ""
    @Published var selectedMeals: [MealCSV] = []
    
    init() {
        loadMeals()
    }
    
    func loadMeals() {
        guard let url = Bundle.main.url(forResource: "mealsDatabase", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            meals = try JSONDecoder().decode([MealCSV].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    var filteredMeals: [MealCSV] {
        if searchText.isEmpty {
            return meals
        } else {
            return meals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
