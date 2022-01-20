//
//  EditCards.swift
//  Flashzilla
//
//  Created by Niral Munjariya on 19/01/22.
//

import SwiftUI

struct EditCards: View {
    @EnvironmentObject var flashCards: FlashCards
    @Environment(\.dismiss) var dismiss
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    
                    Button("Add card", action: addCard)
                }
                
                Section("Available cards") {
                    ForEach(flashCards.allCards) { card in
                        VStack (alignment: .leading) {
                            Text(card.prompt)
                                .font(.headline)
                            
                            Text(card.answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
        }
    }
    
    func done() {
        dismiss()
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        flashCards.addCard(prompt: trimmedPrompt, answer: trimmedAnswer)
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        print("Offsets \(offsets)")
        flashCards.removeCard(at: offsets)
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
    }
}
