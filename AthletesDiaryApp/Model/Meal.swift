//
//  Meal.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 11/05/24.
//

import Foundation
import SwiftUI
import Combine


struct Meal: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let calories: Int
    let fat: Int
    let carbs: Int
    let protein: Int
    let cholesterol: Int
    let description: String
}

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var searchText: String = ""
    @Published var selectedMeals: [Meal] = []
    
    init() {
        loadMeals()
    }
    
    func loadMeals() {
        guard let url = Bundle.main.url(forResource: "meals", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            meals = try JSONDecoder().decode([Meal].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    var filteredMeals: [Meal] {
        if searchText.isEmpty {
            return meals
        } else {
            return meals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}


struct MealListItem: Identifiable, Codable, Hashable {
    var id = UUID()
    let mealId: Int
    let name: String
    let calories: Int
    let fat: Int
    let carbs: Int
    let protein: Int
}

class MealList: ObservableObject {
    @Published var items: [MealListItem] = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    private let storageKey: String
    
    init(storageKey: String) {
        self.storageKey = storageKey
        loadFromUserDefaults()
    }
    
    private func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([MealListItem].self, from: data) {
                self.items = decodedItems
            }
        }
    }
}

class ArchivedMealList: ObservableObject {
    @Published var archivedDays: [[MealListItem]] = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    private let storageKey = "archivedMealList"
    
    init() {
        loadFromUserDefaults()
    }
    
    private func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(archivedDays) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            if let decodedDays = try? decoder.decode([[MealListItem]].self, from: data) {
                self.archivedDays = decodedDays
            }
        }
    }
    
    func archive(breakfast: [MealListItem], lunch: [MealListItem], dinner: [MealListItem], other: [MealListItem]) {
        let todayMeals = breakfast + lunch + dinner + other
        if !todayMeals.isEmpty {
            archivedDays.append(todayMeals)
        }
    }
}
