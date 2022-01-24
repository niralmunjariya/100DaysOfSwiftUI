//
//  Dice.swift
//  RollTheDice
//
//  Created by Niral Munjariya on 21/01/22.
//

import Foundation

struct RollHistory: Codable, Identifiable {
    var id = UUID()
    var dice: [Dice]
    var date = Date.now
    var total: Int
    var sides: Int
}

struct Dice: Codable, Identifiable {
    var id = UUID()
    let sides: Int
    var value: Int
}

@MainActor class DiceViewModel: ObservableObject {
    @Published private(set) var dice: [Dice]
    @Published private(set) var rollTotal: Int = 0
    @Published private(set) var history: [RollHistory]
    @Published private(set) var diceSides: [Int] = [4, 6, 8, 10, 12, 20, 100]
    @Published var numberOfSides: Int = 6
    @Published var numberOfDice: Int = 1
    
    
    private let saveKey = "RollHistory"
    private let maxRolls = 6
    private var rolled = 0
    
    init() {
        dice = []
        history = []
        history = self.loadHistory()
        numberOfSides = diceSides.randomElement() ?? 6
        numberOfDice = Int.random(in: 1..<11)
        self.generateDice()
    }
    
    func loadHistory() -> [RollHistory] {
            var loadedHistory = [RollHistory]()
            let documentDirectory = FileManager.documentsDirectory;
            let filePath = documentDirectory.appendingPathComponent("\(saveKey).json")
            do {
                let data = try Data(contentsOf: filePath)
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([RollHistory].self, from: data)
                loadedHistory = decoded
            } catch {
                history = []
                print("Unable to read data from the json file:")
                print(error.localizedDescription)
            }
        return loadedHistory.sorted(by: { $0.date > $1.date })
        }
    
    func generateDice() {
        rolled = 0
        rollTotal = 0
        var newDice: [Dice] = [Dice]()
        for _ in 0..<numberOfDice {
            let die = Dice(sides: numberOfSides, value: numberOfSides)
            newDice.append(die)
        }
        dice = newDice
    }
    
    func onRollDice() {
        rolled = 0
        rollDice()
    }
    
    private func rollDice() {
        var rolledDice: [Dice] = [Dice]()
        for die in dice {
            var rolledDie = die
            rolledDie.value = Int.random(in: 1...numberOfSides)
            rolledDice.append(rolledDie)
        }
        dice = rolledDice
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if self.maxRolls > self.rolled {
                self.rollDice()
                self.rolled += 1
            } else {
                self.rollTotal = self.getRollTotal()
                self.saveRoll()
            }
        }
    }
    
    private func saveRoll() {
        let rollRecord = RollHistory(dice: dice, total: rollTotal, sides: numberOfSides)
        history.insert(rollRecord, at: 0)
        saveHistory()
    }
    
    private func getRollTotal() -> Int {
        var total: Int = 0
        for die in dice {
            total += die.value
        }
        return total
    }
    
    private func saveHistory() {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(history) {
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
