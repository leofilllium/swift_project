//
//  MainScreen.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 13/05/24.
//

import SwiftUI

struct MainScreen: View {
    @StateObject private var viewModel = PeopleViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.people.indices, id: \.self) { index in
                        let person = viewModel.people[index]
                        ThreadView(
                            mainImage: person.mainImage,
                            profileImage: person.profileImage,
                            heartLogic: Binding<Bool>(
                                get: { !person.isLiked },
                                set: { viewModel.people[index].isLiked = !$0 }
                            ),
                            name: person.username
                        )
                    }
                }
                .navigationTitle("People")
            }
        }
    }
}



struct ThreadView: View {
    var mainImage: String
    var profileImage: String
    @Binding var heartLogic: Bool
    var name: String
    @State private var isLiked = false
    @State private var animationAmount = 1.0
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: mainImage)!){
                image in image.image?
                    .resizable()
                    .aspectRatio(3/4,contentMode: .fill)
            }
                .cornerRadius(10)
            HStack {
                AsyncImage(url: URL(string: profileImage))
                    .clipped()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .cornerRadius(360)
                
                Text(name)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.heartLogic.toggle()
                    }
                }) {
                    Image(systemName: heartLogic ? "heart.fill" : "heart")
                        .font(.system(size: 30))
                        .foregroundColor(heartLogic ? Color.accentColor : .gray)
                       
                }
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .gesture(
            TapGesture(count: 2)
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.heartLogic.toggle()
                    }
                }
        )
        .padding()
    }
}


#Preview {
    MainScreen()
}
