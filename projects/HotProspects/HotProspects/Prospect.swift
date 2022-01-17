//
//  Prospect.swift
//  HotProspects
//
//  Created by Niral Munjariya on 17/01/22.
//

import SwiftUI

class Prospect: Codable, Identifiable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var createdDate = Date.now
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
    
    let randomProspects: [String] = [
        "Anthony Hopkins\nanthony@hopkinsmail.com",
        "Sheldon Cooper\nsheldon@bigbangtheory.com",
        "Tim Cook\ntim@apple.com",
        "Paul Hudson\npaul@hackingwithswift.com",
        "Walter White\nwalter@breakingbad.com",
        "Nora Durst\nnoradurst@gmail.com"
    ]
    
    init() {
        let documentDirectory = FileManager.documentsDirectory;
        let filePath = documentDirectory.appendingPathComponent("\(saveKey).json")
        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode([Prospect].self, from: data)
            people = decoded
        } catch {
            people = []
            print("Unable to read data from the json file:")
            print(error.localizedDescription)
        }
    }
    
    
    func addProspect(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    private func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let encoded = try? encoder.encode(people) {
            
            let documentDirectory = FileManager.documentsDirectory;
            let filePath = documentDirectory.appendingPathComponent("\(saveKey).json")
            do {
                try encoded.write(to: filePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data to json file:")
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteProspect(_ prospect: Prospect){
        guard let index = people.firstIndex(where: { $0.id == prospect.id}) else { return }
        if index >= 0 {
            people.remove(at: index)
            save()
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
