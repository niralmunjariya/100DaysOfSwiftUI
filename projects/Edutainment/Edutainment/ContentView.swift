//
//  ContentView.swift
//  Edutainment
//
//  Created by Derek on 12/5/21.
//

import SwiftUI

struct Question {
    var multiplier1: Int = 0
    var multiplier2: Int = 0
    
    var question: String {
        return "\(multiplier1) x \(multiplier2)"
    }
    
    var answer: Int {
        return multiplier1 * multiplier2
    }
    
    var options: [Int] {
        var options = [Int]()
        for _ in 0...9 {
            let option = Int.random(in: 1...12)
            if options.count < 4 && !options.contains(multiplier1 * option) {
                options.append(multiplier1 * option)
            }
        }
        if !options.contains(answer){
            options.remove(at: 0)
            options.append(answer)
        }
        
        return options.shuffled()
    }
}

enum ViewMode {
    case defaultView, questionView, resultView
}

struct RoundButton: ViewModifier {
    var selected: Bool = false
    func body(content: Content) -> some View {
        content
            .font(.title)
            .frame(width: 50, height: 50)
            .background(selected ? .blue : .gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .foregroundColor(.white)
            .animation(.default, value: selected)
    }
}

struct ContentView: View {
    /**
     Settings
     1. Which multiplication table they want to practice from 2 to 12
     2. How many questions they want to be asked: 5, 10 or 20
     */
    
    @State private var viewMode: ViewMode = .defaultView
    
    // Settings
    @State private var selectedTables: [Int] = [Int.random(in: 1...12)]
    private var questionVariants = [5, 10, 15, 20]
    @State private var numberOfQuestionsToAsk: Int = 5
    
    
    @State private var questions = [Question]()
    @State private var questionNumber = 0
    @State private var counter = 0
    
    @State private var score = 0
    
    private var scoreRating: String{
        var rating = ""
        let percentage = (score * 100) / questions.count
        if percentage >= 90 {
            rating = "Awesome! 😃"
        } else if percentage >= 70 {
            rating = "Wow! 😊"
        } else if percentage >= 50 {
            rating = "You did well! 😌"
        } else {
            rating = "Keep trying 😔"
        }
        return rating
    }
    
    var body: some View {
        NavigationView{
            
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.blue, .cyan, .yellow, .pink]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Section {
                    VStack (spacing: 20) {
                        
                        VStack{
                            Text("Fun Tables")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .shadow(radius: 1)
                            Text("Test your table skills")
                                .font(.subheadline)
                                .opacity(0.8)
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()
                        
                        VStack {
                            
                            if viewMode == .questionView && questionNumber >= 0 {
                                VStack (spacing: 50) {
                                    
                                    Spacer()
                                    
                                    VStack (spacing: 10){
                                        Text("Question \(questionNumber + 1) of \(questions.count)")
                                            .foregroundStyle(.secondary)
                                        
                                        Text(questions[questionNumber].question)
                                            .font(.system(size: 80))
                                            .foregroundColor(.black)
                                            .shadow(radius: 2)
                                    }
                                    
                                    VStack (spacing: 20){
                                        Text("Select your answer")
                                            .foregroundStyle(.secondary)
                                        HStack (spacing: 20) {
                                            ForEach(questions[questionNumber].options, id: \.self) { option in
                                                Button("\(option)") {
                                                    onAnswerSelect(option)
                                                }
                                                .modifier(RoundButton())
                                                .font(.largeTitle)
                                            }
                                        }
                                    }
                                    
                                    Text("Score \(score)/\(questions.count)")
                                        .font(.title)
                                        .shadow(radius: 2)
                                    
                                    Spacer()
                                    
                                }
                                
                            } else if viewMode == .resultView {
                                
                                Spacer()
                                
                                VStack (spacing: 20){
                                    
                                    Text("\(scoreRating)")
                                        .font(.largeTitle)
                                    
                                    Text("Your score is")
                                        .font(.title2)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("\(score)")
                                        .font(.system(size: 100))
                                    
                                    Text("out of \(questions.count)")
                                        .font(.title2)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Button("Restart") {
                                    restartGame()
                                }
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .background(.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                                                
                            }  else {
                                
                                Spacer()
                                
                                VStack (spacing: 50) {
                                    VStack{
                                        Text("Select tables")
                                            .font(.title2)
                                            .foregroundStyle(.secondary)
                                        VStack(spacing: 20){
                                            ForEach(0..<3, id: \.self){ row in
                                                HStack (spacing: 20)  {
                                                    ForEach(1..<5, id: \.self) { col in
                                                        Button("\(row * 4 + col)") {
                                                            onTableSelect(row * 4 + col)
                                                        }
                                                        .modifier(RoundButton(selected: selectedTables.contains(row * 4 + col)))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                    VStack{
                                        Text("Number of questions")
                                            .font(.title2)
                                            .foregroundStyle(.secondary)
                                        
                                        HStack (spacing: 20) {
                                            ForEach(questionVariants, id: \.self) { variant in
                                                Button("\(variant)") {
                                                    numberOfQuestionsToAsk = variant
                                                }
                                                .modifier(RoundButton(selected: numberOfQuestionsToAsk == variant))
                                            }
                                        }
                                    }
                                    
                                    Button("Start") {
                                        startGame()
                                    }
                                    .font(.largeTitle)
                                    .frame(maxWidth: .infinity, minHeight: 70)
                                    .background(.cyan)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    
                                }
                                
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Spacer()
                        
                    }
                }
            }
        }
    }
    
    func onTableSelect(_ table: Int){
        if let index = selectedTables.lastIndex(of: table){
            selectedTables.remove(at: index)
        } else {
            selectedTables.append(table)
        }
    }
    
    func onAnswerSelect(_ answer: Int){
        let currentQuestion = questions[questionNumber];
        if currentQuestion.answer == answer{
            withAnimation{
                score += 1
            }
        }
        if questionNumber < (questions.count - 1) {
            withAnimation{
                questionNumber += 1
            }
        } else {
            withAnimation{
                viewMode = .resultView
            }
        }
    }
    
    func generateQuestions(){
        let questionsPerTable = numberOfQuestionsToAsk / selectedTables.count + 1;
        for table in selectedTables {
            for _ in 0...questionsPerTable {
                if questions.count < numberOfQuestionsToAsk{
                    let multiplier2 = Int.random(in: 1...12)
                    let question = Question(multiplier1: table, multiplier2: multiplier2)
                    questions.append(question)
                }
            }
        }
        questions.shuffle()
    }
    
    func startGame(){
        questionNumber = 0
        questions.removeAll()
        generateQuestions()
        withAnimation{
            viewMode = .questionView
        }
    }
    
    func restartGame(){
        withAnimation{
            score = 0
            viewMode = .defaultView
            questionNumber = 0
            numberOfQuestionsToAsk = 5
            selectedTables = [Int.random(in: 1...12)]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
