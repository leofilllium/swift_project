//
//  DietScreen.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 10/05/24.
//

import SwiftUI


struct DietScreen: View {
    @State private var isBreakfastShowing = false
    @State private var isLunchShowing = false
    @State private var isDinnerShowing = false
    @State private var isOtherShowing = false
    
    @ObservedObject var breakfastList = MealList(storageKey: "breakfastList")
    @ObservedObject var lunchList = MealList(storageKey: "lunchList")
    @ObservedObject var dinnerList = MealList(storageKey: "dinnerList")
    @ObservedObject var otherList = MealList(storageKey: "otherList")
    
    @StateObject private var archivedMealList = ArchivedMealList()
    
    @State private var isShowingSecondScreen = false
    
    @State private var isPressed = false
    @State private var waterPressed = false
    
    private let lastUpdatedKey = "lastUpdatedDate"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                ScrollView{
                    VStack {
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(totalCalories)")
                                .foregroundStyle(Color.accentColor)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Calories")
                                .foregroundStyle(Color.gray)
                            Spacer()
                            Button(action: {
                                self.isShowingSecondScreen.toggle()
                            }) {
                                Image(systemName: "plus")
                            }
                            .font(.title2)
                        }
                        .padding()
                        ZStack(){
                            if isBreakfastShowing {
                                OutlineOfMeals(
                                    title: "Breakfast",
                                    isShowing: $isBreakfastShowing,
                                    cal: categoryCalories(breakfastList.items),
                                    randomItems: breakfastList.items
                                )
                            }
                            if isLunchShowing {
                                OutlineOfMeals(
                                    title: "Lunch",
                                    isShowing: $isLunchShowing,
                                    cal: categoryCalories(lunchList.items),
                                    randomItems: lunchList.items
                                )
                            }
                            if isDinnerShowing {
                                OutlineOfMeals(
                                    title: "Dinner",
                                    isShowing: $isDinnerShowing,
                                    cal: categoryCalories(dinnerList.items),
                                    randomItems: dinnerList.items
                                )
                            }
                            if isOtherShowing {
                                OutlineOfMeals(
                                    title: "Other",
                                    isShowing: $isOtherShowing,
                                    cal: categoryCalories(otherList.items),
                                    randomItems: otherList.items
                                )
                            }
                            else if isBreakfastShowing == false && isLunchShowing == false && isDinnerShowing == false && isOtherShowing == false {
                                VStack(spacing: 0){
                                    HStack(spacing: 0){
                                        DietTypeContainer(name: "Breakfast", imageName: "cup.and.saucer.fill", colorName: .yellow, count: categoryCalories(breakfastList.items))
                                            .onTapGesture {
                                                withAnimation {
                                                    self.isBreakfastShowing.toggle()
                                                }
                                            }
                                        DietTypeContainer(name: "Lunch", imageName: "takeoutbag.and.cup.and.straw.fill", colorName: .indigo, count: categoryCalories(lunchList.items))
                                            .onTapGesture {
                                                withAnimation {
                                                    self.isLunchShowing.toggle()
                                                }
                                            }
                                    }
                                    
                                    HStack(spacing: 0){
                                        DietTypeContainer(name: "Dinner", imageName: "fork.knife.circle.fill", colorName: .pink, count: categoryCalories(dinnerList.items))
                                            .onTapGesture {
                                                withAnimation {
                                                    self.isDinnerShowing.toggle()
                                                }
                                            }
                                        DietTypeContainer(name: "Other", imageName: "carrot.fill", colorName: .gray, count: categoryCalories(otherList.items))
                                            .onTapGesture {
                                                withAnimation {
                                                    self.isOtherShowing.toggle()
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(
                            top: 0, leading: 6, bottom: 0, trailing: 6
                        ))
                        HStack{
                            Image(systemName: "drop.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding()
                                .aspectRatio(1, contentMode: .fit)
                                .background(Color.blue)
                                .cornerRadius(15)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                            VStack(alignment: .leading){
                                Text("Water Intake")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                Text("100 gram")
                                    .foregroundStyle(Color.gray)
                            }
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .scaleEffect(waterPressed ? 0.9 : 1.0)
                        .animation(.easeOut(duration:0.2), value: waterPressed)
                        .onTapGesture{}
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged{ _ in
                                    waterPressed = true
                                }
                                .onEnded{ _ in
                                    waterPressed = false
                                }
                        )
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 5, trailing: 16))
                        NavigationLink(destination: StatisticsView()){
                            HStack {
                                Image(systemName: "chart.pie.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .padding()
                                    .aspectRatio(1, contentMode: .fit)
                                    .background(Color.green)
                                    .cornerRadius(15)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                Text("Statistics")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .foregroundStyle(Color.white)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .padding(EdgeInsets(top: 5, leading: 16, bottom: 16, trailing: 16))
                        }
                    }
                }
                
            }
            .sheet(isPresented: $isShowingSecondScreen) {
                DietForm(
                    breakfastList: breakfastList,
                    lunchList: lunchList,
                    dinnerList: dinnerList,
                    otherList: otherList
                )
            }
            .navigationTitle("Diet")
        }
        .onAppear {
            checkAndRefreshDataIfNeeded()
        }
    }
    
    private var totalCalories: Int {
        categoryCalories(breakfastList.items) +
        categoryCalories(lunchList.items) +
        categoryCalories(dinnerList.items) +
        categoryCalories(otherList.items)
    }
    
    private func categoryCalories(_ items: [MealListItem]) -> Int {
        items.reduce(0) { $0 + $1.calories }
    }
    
    private func checkAndRefreshDataIfNeeded() {
        let lastUpdated = UserDefaults.standard.object(forKey: lastUpdatedKey) as? Date ?? Date.distantPast
        if !Calendar.current.isDateInToday(lastUpdated) {
            refreshData()
        }
    }
    
    private func refreshData() {
        archivedMealList.archive(
            breakfast: breakfastList.items,
            lunch: lunchList.items,
            dinner: dinnerList.items,
            other: otherList.items
        )
        breakfastList.items.removeAll()
        lunchList.items.removeAll()
        dinnerList.items.removeAll()
        otherList.items.removeAll()
        UserDefaults.standard.set(Date(), forKey: lastUpdatedKey)
    }
    
}

                            

                        

struct DietTypeContainer: View{
    
    let name: String
    let imageName: String
    let colorName: Color
    let count: Int
    
    var body: some View{
        VStack{
            Image(systemName: imageName)
                .foregroundColor(.white)
                .font(.title2)
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .background(colorName)
                .cornerRadius(15)
            Text(name)
                .fontWeight(.bold)
                .font(.title3)
            Text("\(count) cal")
                .foregroundStyle(Color.gray)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
    
}



struct OutlineOfMeals: View{
    
    var title: String
    @Binding var isShowing: Bool
    var cal: Int
    var randomItems: [MealListItem]
    
    var body: some View{
        VStack(spacing:0){
            HStack{
                VStack{
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Button(action:{
                    withAnimation{
                        self.isShowing.toggle()
                    }
                }){
                    Text("Back")
                        .foregroundStyle(Color.accentColor)
                }
            }
            HStack{
                Text("\(cal) cal")
                Spacer()
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            VStack(spacing: 25){
                if(randomItems.isEmpty){
                    Text("The \(title.lowercased()) is empty")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.gray)
                }
                else{
                    ForEach(randomItems, id: \.self) { user in
                        Text(user.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }.frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding(EdgeInsets(
            top: 10, leading: 10, bottom: 10, trailing: 10
            ))
    }
}



struct StatisticsView: View{
    @ObservedObject var breakfastList = MealList(storageKey: "breakfastList")
    @ObservedObject var lunchList = MealList(storageKey: "lunchList")
    @ObservedObject var dinnerList = MealList(storageKey: "dinnerList")
    @ObservedObject var otherList = MealList(storageKey: "otherList")
    var body: some View{
            ScrollView{
                VStack{
                    SectorChartExample(breakfastList: breakfastList, lunchList: lunchList, dinnerList: dinnerList, otherList: otherList)
                    SectorChartExample(breakfastList: breakfastList, lunchList: lunchList, dinnerList: dinnerList, otherList: otherList)
                    SectorChartExample(breakfastList: breakfastList, lunchList: lunchList, dinnerList: dinnerList, otherList: otherList)
                }
            }
        .navigationTitle("Statistics")
    }
}
#Preview {
    DietScreen()
}
