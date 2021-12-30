//
//  Habit.swift
//  MyHabits
//
//  Created by Derek on 12/8/21.
//

import Foundation



struct Habit: Codable, Identifiable, Equatable {
    static var Good = "Good"
    static var Bad = "Bad"
    static var Types = [Good, Bad]
    
    struct Log: Codable, Identifiable {
        var id = UUID()
        let date: Date
        let note: String
        
        init(note: String){
            self.date = Date.now
            self.note = note
        }
    }
    
    var id = UUID()
    let title: String
    let description: String
    let type: String
    var logs: [Log] = []
    var createdDate: Date = Date.now
    var count: Int
    
    var formattedCreatedDate: String {
        return createdDate.formatted(date: .abbreviated, time: .omitted)
//        return createdDate.formatted(date: .abbreviated, time: .shortened)
    }

    static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.id == rhs.id
    }
    
    init(title: String, description: String, type: String){
        self.title = title
        self.description = description
        self.type = type
        self.count = 0
        self.logs = []
    }
    
    
}
