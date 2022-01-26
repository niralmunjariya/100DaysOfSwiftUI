//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Niral Munjariya on 26/01/22.
//

import Foundation

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        let documentDirectory = FileManager.documentsDirectory;
        let filePath = documentDirectory.appendingPathComponent("\(saveKey).json")
        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(Set<String>.self, from: data)
            resorts = decoded
        } catch {
            resorts = []
            print("Unable to read data from the json file:")
            print(error.localizedDescription)
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    private func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(resorts) {
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
