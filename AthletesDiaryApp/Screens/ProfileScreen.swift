//
//  ProfileScreen.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 13/05/24.
//

import SwiftUI
import HealthKit


struct ProfileScreen: View {
    let healthStore = HKHealthStore()
    @State private var stepCount: Double?

    var body: some View {
        NavigationView{
            List{
                Section{
                    HStack{
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                        VStack{
                            Text("Sherzod Akhmedov")
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("75 kg")
                                .foregroundStyle(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                }
                Section("Steps Today"){
                    HStack{
                        Image(systemName: "shoeprints.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text("\(Int((stepCount ?? 0)))")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                }
                Section("Others"){
                    HStack{
                        Image(systemName: "chart.pie.fill")
                            .frame(width: 30, height: 30)
                            .background(.selection)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                        Text("Statistics")
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    HStack{
                        Image(systemName: "lightbulb.fill")
                            .frame(width: 30, height: 30)
                            .background(.orange)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                        Text("Suggestions")
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    HStack{
                        Image(systemName: "powersleep")
                            .frame(width: 30, height: 30)
                            .background(.blue)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                        Text("Sleep")
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    
                    HStack{
                        Image(systemName: "figure.stairs")
                            .frame(width: 30, height: 30)
                            .background(.red)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                        Text("Progress")
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    HStack{
                        Image(systemName: "figure.mixed.cardio")
                            .frame(width: 30, height: 30)
                            .background(.brown)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                        Text("Body Measurement")
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                }
                Section{
                    HStack{
                        Image(systemName: "apps.iphone")
                            .frame(width: 30, height: 30)
                            .background(.link)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                        Text("More Apps")
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    HStack{
                        Image(systemName: "crown")
                            .frame(width: 30, height: 30)
                            .background(.yellow)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                        Text("Premium")
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    HStack{
                        Image(systemName: "gearshape.2.fill")
                            .frame(width: 30, height: 30)
                            .background(.gray)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                        Text("Settings")
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    
                }
            }
            .navigationTitle("Profile")
        } .onAppear {
            Task {
                await requestAuthorization()
                fetchStepCount(for: Date())
            }
        }
    }
    
    func requestAuthorization() async {
        let readTypes: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
            print("Authorization granted.")
        } catch {
            print("Authorization denied: \(error.localizedDescription)")
        }
    }
    
    func fetchStepCount(for day: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: day)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    print("Error fetching step count for \(day): \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.stepCount = sum.doubleValue(for: HKUnit.count())
            }
        }
        healthStore.execute(query)
    }
}

#Preview {
    ProfileScreen()
}
