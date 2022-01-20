//
//  Card.swift
//  Flashzilla
//
//  Created by Niral Munjariya on 18/01/22.
//

import Foundation

struct Card: Codable, Identifiable {
    var id: UUID = UUID()
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}



@MainActor class FlashCards: ObservableObject {
    @Published private(set) var cards: [Card]
    private(set) var allCards: [Card] = [Card]()
    let saveKey = "FlashCards"
    
    init() {
        cards = []
        cards = self.loadSavedCards()
    }
    
    
    func loadSavedCards() -> [Card] {
        var loadedCards = [Card]()
        let documentDirectory = FileManager.documentsDirectory;
        let filePath = documentDirectory.appendingPathComponent("\(saveKey).json")
        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Card].self, from: data)
            loadedCards = decoded
            allCards = decoded
        } catch {
            loadedCards = [Card.example]
            print("Unable to read data from the json file:")
            print(error.localizedDescription)
        }
        return loadedCards
    }
    
    func reloadCards() {
        cards = loadSavedCards().shuffled()
    }
    
    
    func addCard(prompt: String, answer: String) {
        let card = Card(prompt: prompt, answer: answer)
        cards.append(card)
        save()
    }
    
    func removeCard(card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            guard index >= 0 else { return }
            cards.remove(at: index)
        }
    }
    
    func removeCard(at offsets: IndexSet) {
        if !cards.isEmpty {
            cards.remove(atOffsets: offsets)
        }
    }
    
    func restoreCard(card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            guard index >= 0 else { return }
            let removedCard = cards.remove(at: index)
            // Even though object is added to the array it was not reflecting in the UI, after googing a bit, I found this
            // https://www.hackingwithswift.com/forums/100-days-of-swiftui/day-91-flashzilla-challenges-can-t-seem-to-readd-a-card-successfully/2037
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                self.cards.insert(removedCard, at: 0)
            }
        }
    }
    
    private func save() {
        allCards = cards
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cards) {
            let documentDirectory = FileManager.documentsDirectory;
            let filePath = documentDirectory.appendingPathComponent("\(saveKey).json")
            do {
                try encoded.write(to: filePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to write data to json file:")
                print(error.localizedDescription)
            }
        }
    }
}
