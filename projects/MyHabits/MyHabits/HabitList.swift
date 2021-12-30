//
//  HabitList.swift
//  MyHabits
//
//  Created by Derek on 12/8/21.
//

import Foundation

class HabitList: ObservableObject {
    @Published var habits: [Habit] {
        didSet {
            if let encoded = try? JSONEncoder().encode(habits){
                UserDefaults.standard.set(encoded, forKey: "MyHabits")
            }
        }
    }
    
    var goodHabits: [Habit] {
        return habits.filter{ habit in
            habit.type == Habit.Good
        }
    }
    
    var badHabits: [Habit] {
        return habits.filter{ habit in
            habit.type == Habit.Bad
        }
    }
    
    init() {
        if let savedHabits = UserDefaults.standard.data(forKey: "MyHabits"){
            if let decodedHabits = try? JSONDecoder().decode([Habit].self, from: savedHabits){
                habits = decodedHabits
                return
            }
        }
        habits = []
    }
}
