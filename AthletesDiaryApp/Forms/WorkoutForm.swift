//
//  WorkoutForm.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 13/06/24.
//

import SwiftUI

struct WorkoutForm: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var isPresented = true
    var body: some View {
        NavigationView{
            Form{
                List(viewModel.filteredMeals, id: \.id){ exercise in
                    NavigationLink(destination: ExerciseView(exercises: exercise)){
                        VStack(alignment: .leading){
                            Text(exercise.name)
                            Text(exercise.category?.capitalized ?? "")
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText, isPresented: $isPresented, prompt: "Search Exercises")
            .navigationTitle("Add Exercises")
        }
    }
}

struct ExerciseView: View{
    var exercises: Exercise
    var body: some View{
        VStack(alignment: .leading){
            Text(exercises.name)
            Text(exercises.category ?? "")
            Text("Instructions:")
            ForEach(exercises.instructions ?? [], id: \.self){
                instructions in
                Text("* \(instructions)")
            }
        }
    }
}

#Preview {
    WorkoutForm()
}
