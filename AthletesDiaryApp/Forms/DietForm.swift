//
//  DietForm.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 10/05/24.
//

import SwiftUI


struct DietForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = MealCSVViewModel()
    @State private var selectedCategory: String = ""
    @State private var mealSelect: [Int: Bool] = [:]
    
    @ObservedObject var breakfastList: MealList
    @ObservedObject var lunchList: MealList
    @ObservedObject var dinnerList: MealList
    @ObservedObject var otherList: MealList
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Category", selection: $selectedCategory) {
                    Text("Breakfast").tag("Breakfast")
                    Text("Lunch").tag("Lunch")
                    Text("Dinner").tag("Dinner")
                    Text("Other").tag("Other")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Section {
                    List(viewModel.filteredMeals, id: \.id) { meal in
                        NavigationLink(destination: MealDetailsView(meal: meal)) {
                            HStack {
                                Image(systemName: mealSelect[meal.id, default: false] ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundStyle(Color(hex: "#c4ff00"))
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            self.mealSelect[meal.id]?.toggle()
                                        }
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                    .foregroundStyle(Color(hex: "#c4ff00"))
                                VStack(alignment: .leading) {
                                    Text(meal.name)
                                        .font(.headline)
                                    Text("\(meal.calories ?? 0) cal")
                                        .foregroundStyle(Color.gray)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    let currentDate = Date()
                    selectedCategory = await getMealTime(currentDate)
                }
                for meal in viewModel.filteredMeals {
                    mealSelect[meal.id] = false
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search Meals")
            .navigationBarItems(trailing: Button("Add"){
                let selectedMeals = viewModel.filteredMeals.filter { mealSelect[$0.id, default: false] }
                for meal in selectedMeals {
                    let newItem = MealListItem(
                        mealId: meal.id,
                        name: meal.name,
                        calories: meal.calories ?? 0,
                        fat: Int(meal.fattyAcidsSaturated ?? 0),
                        carbs: Int(meal.carbohydrate ?? 0),
                        protein: Int(meal.protein ?? 0)
                    )
                    switch selectedCategory {
                    case "Breakfast":
                        breakfastList.items.append(newItem)
                    case "Lunch":
                        lunchList.items.append(newItem)
                    case "Dinner":
                        dinnerList.items.append(newItem)
                    default:
                        otherList.items.append(newItem)
                    }
                }
                self.presentationMode.wrappedValue.dismiss()
            }.foregroundStyle(Color(hex: "#c4ff00"))
            )
            .navigationTitle("Add Meals")
        }
    }
    
    func getMealTime(_ date: Date) async -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        switch hour {
        case 4...11:
            return "Breakfast"
        case 12...16:
            return "Lunch"
        case 17...23, 0...3:
            return "Dinner"
        default:
            return "Other"
        }
    }
}



struct MealDetailsView: View{
    let meal: MealCSV
    var body: some View{
        Text(meal.name)
    }
}

#Preview {
    DietForm(breakfastList: MealList(storageKey: "breakfastList"), lunchList: MealList(storageKey: "lunchList"), dinnerList: MealList(storageKey: "dinnerList"), otherList: MealList(storageKey: "otherList"))
}
