//
//  ContentView.swift
//  Flashzilla
//
//  Created by Niral Munjariya on 18/01/22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @StateObject var flashCards = FlashCards()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var isActive = true
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(flashCards.cards) { card in
                        CardView(card: card) { isCorrect in
                            withAnimation {
                                if isCorrect {
                                    flashCards.removeCard(card: card)
                                } else {
                                    flashCards.restoreCard(card: card)
                                }
                            }
                        }
                        .stacked(at: getIndex(card: card), in: flashCards.cards.count)
                        .allowsHitTesting(getIndex(card: card) == flashCards.cards.count - 1)
                        .accessibilityHidden(getIndex(card: card) < flashCards.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if flashCards.cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                .padding()
                
                Spacer()
            }
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                flashCards.restoreCard(card: flashCards.cards[flashCards.cards.count - 1])
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                flashCards.removeCard(card: flashCards.cards[flashCards.cards.count - 1])
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive && !flashCards.cards.isEmpty else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if !flashCards.cards.isEmpty {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
                .environmentObject(flashCards)
        }
        .onAppear(perform: resetCards)
    }
    
    func resetCards() {
        flashCards.reloadCards()
        timeRemaining = 100
        isActive = true
    }
    
    func getIndex(card: Card) -> Int {
        var index = 0
        if !flashCards.cards.isEmpty {
            index = flashCards.cards.firstIndex(where: { $0.id == card.id }) ?? 0
        }
        return index
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
