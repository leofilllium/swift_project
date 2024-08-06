//
//  WorkoutScreen.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 13/05/24.
//

import SwiftUI

struct WorkoutScreen: View{
    
    @StateObject private var viewModel = ExerciseViewModel()
    
    @State private var isShowingSecondScreen = false
    
    @State private var workoutExpand: Bool = false
    @State var timeCountDown = 0.0
    @State var pause = true
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View{
        NavigationView{
            ScrollView{
                VStack{
                    ZStack{
                        if workoutExpand {
                            VStack{
                                HStack{
                                    Text("Currently Working Out")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Button(action:{
                                        self.isShowingSecondScreen.toggle()
                                    }){
                                        Image(systemName: "plus")
                                    }
                                }
                                Text("Add Exercises")
                                        .font(.title3)
                                        .foregroundStyle(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(formattedTime(timeCountDown))")
                                    .onReceive(timer){ _ in
                                        if(pause == false){
                                            timeCountDown += 0.01
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                
                                VStack(spacing: 25){
                                    Text("Item 1")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Item 2")
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                    Text("Item 3")
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                    Text("Item 4")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }.frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .padding(EdgeInsets(
                                top: 0, leading: 0, bottom: 19, trailing: 0
                                ))
                                
                                HStack{
                                    Button(action:{
                                        self.pause.toggle()
                                    }){
                                        Image(systemName: pause ? "play.fill" : "pause.fill")
                                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                            .frame(maxWidth: .infinity)
                                            .background(Color("myLightBlue"))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    Button(action:{
                                        self.pause = true
                                        self.timeCountDown = 0.0
                                        withAnimation{
                                            self.workoutExpand.toggle()
                                        }
                                    }){
                                        Image(systemName: "stop.fill")
                                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                            .frame(maxWidth: .infinity)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .padding()
                            
                        } else{
                            VStack{
                                Text("Start a Workout")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("and add exercises now")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                                
                                Button(action:{
                                    withAnimation{
                                        self.workoutExpand.toggle()
                                    }
                                    self.pause.toggle()
                                }){
                                    Text("Start")
                                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                        .frame(maxWidth: .infinity)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .padding()
                        }
                    }
                    HStack{
                        Text("Your Routines")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action:{
                            
                        }){
                            Image(systemName: "plus")
                                .font(.title2)
                        }
                        .foregroundStyle(Color.accentColor)
                    }
                    .padding()
                    RoutinesContainer(title: "Title", subTitle: "Bench Press (Barbell)")
                    RoutinesContainer(title: "Title 2", subTitle: "Push ups")

                    HStack{
                        Text("Recommeded Routines")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action:{
                            
                        }){
                            Text("See more")
                        }
                        .foregroundStyle(Color.accentColor)
                    }
                    .padding()
                    RoutinesContainer(title: "Title", subTitle: "Bench Press (Barbell)")
                    RoutinesContainer(title: "Title 2", subTitle: "Push ups")
                }
            }
            .sheet(isPresented: $isShowingSecondScreen) {
                WorkoutForm()
            }
            
            .navigationTitle("Workouts")
            
        }
    }
    func formattedTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = Int(time * 100) % 100
        
        return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds)
    }
}


struct RoutinesContainer: View{
    
    var title: String
    var subTitle: String
    
    var body: some View{
        VStack(alignment: .leading){
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(subTitle)
                .foregroundStyle(Color.gray)
                .font(.callout)
            Button(action:{
                
            }){
                Text("Start")
            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
            
        }.padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
    }
}


#Preview {
    WorkoutScreen()
}
