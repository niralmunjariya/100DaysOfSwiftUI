//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Derek on 11/21/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingResult = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0;
    @State private var attemptedQuestions = 0;
    @State private var rotationAmount = 0.0
    private var totalScore = 8;
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.7, green: 0.2, blue: 0.5), location: 0.3),
                .init(color: Color(red: 0.3, green: 0.6, blue: 04), location: 0.3)
            ], center: .top, startRadius: 150, endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .shadow(radius: 5)
                
                Spacer()
                
                VStack (spacing: 20){
                    VStack(spacing: 10) {
                        Text("Question \(attemptedQuestions+1)")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.bold())
                    }
                    
                    VStack(spacing: 20){
                        ForEach(0..<3) { number in
                            Button{} label: {
                                Image(countries[number])
                                    .renderingMode(.original)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(radius: 5)
                                    .rotation3DEffect(.degrees(number == correctAnswer ? rotationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                                    .onTapGesture {
                                        withAnimation {
                                            rotationAmount = 360
                                        }
                                        flagTapped(number)
                                        rotationAmount = 0.0
                                    }
                                    .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score \(score)/\(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .shadow(radius: 5)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Spacer()
            Text("Your score is \(score)/\(totalScore)")
        }
        .alert(scoreTitle, isPresented: $showingResult){
            Button("Restart", action: restart)
        } message: {
            Text("Your final score is \(score)/\(totalScore)")
        }
    }
    
    func flagTapped(_ number: Int){
        if(number == correctAnswer){
            scoreTitle = "Correct!"
            score += 1;
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        if(attemptedQuestions >= 7){
            showingResult = true
            if(score >= 4){
                scoreTitle = "You did well!"
            } else {
                scoreTitle = "You need try little harder."
            }
        } else {
            showingScore = true
        }
    }
    
    func askQuestion(){
        attemptedQuestions += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restart(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        score = 0
        scoreTitle = ""
        showingScore = false
        attemptedQuestions = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
