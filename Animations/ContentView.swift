//
//  ContentView.swift
//  Animations
//
//  Created by Jesus Calleja on 9/10/22.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "USA"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var selected = 5
    @State private var initState: Bool = true
    @State private var showingAlert: Bool = false
    @State private var showingReset: Bool = false
    @State private var scoreTitle: String = ""
    @State private var scoreMessage: String = ""
    @State private var score: Int = 0
    @State private var numberOfTaps: Int = 0
    @State private var rotationDegrees = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                                                Color.gray,
                                                Color.blue,
                                                Color.black
            ]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation {
                            initState = false
                            selected = number
                            rotationDegrees += 360
                            flagTapped(number)
                        }
                    })
                    {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .overlay(RoundedRectangle(cornerRadius: 15.0).stroke(Color.gray, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                            .opacity(!initState && (number != selected) ? 0.1 : 1.0)
                            .scaleEffect(!initState && (number != selected) ? 0.5 : 1.0 )
                            .rotation3DEffect(.degrees(number == selected ? rotationDegrees : 0), axis: (x: 0, y: 1, z: 0))
                    }
                    

                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(scoreTitle),
                          message: Text(scoreMessage),
                          dismissButton: .default(Text("Continue")) {
                        askQuestion()
                    }
                    )
                }
                Spacer()
                VStack(spacing: 20) {
                    Text("Your score is \(score)/\(numberOfTaps)")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.medium)
                    Button(action: { showingReset = true }, label: {
                        Text("Reset")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                    })
                    .padding(.vertical, 15)
                    .padding(.horizontal, 40)
                    .background(Color.gray)
                    .cornerRadius(15)
                    .shadow(color: .white, radius: 4)
                    .alert(isPresented: $showingReset) {
                        Alert(title: Text("Do you want to reset?"),
                              message: Text("If you press Reset your score will go back to 0/0"),
                              primaryButton: .destructive(Text("Reset"), action: { reset() } ),
                              secondaryButton: .cancel()
                        )
                    }

                }
                Spacer()
            }
        }
    }

    func flagTapped(_ number: Int) {
        numberOfTaps += 1
        if number == correctAnswer {
            scoreTitle = "Correct ✅"
            scoreMessage = "Well done!"
            score += 1
        } else {
            scoreTitle = "Wrong... 😕"
            scoreMessage = "That was the flag of \(countries[number])."
        }
        showingAlert = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selected = 5
        initState = true
    }
    
    func reset() {
        score = 0
        numberOfTaps = 0
        askQuestion()
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
