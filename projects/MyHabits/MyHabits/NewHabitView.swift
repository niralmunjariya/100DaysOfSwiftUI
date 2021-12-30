//
//  NewHabitView.swift
//  MyHabits
//
//  Created by Derek on 12/8/21.
//

import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habitList: HabitList
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var type: String = Habit.Good
    @State private var hasAnyError = false
    
    let types = Habit.Types
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    
                    TextField("Title", text: $title)
                    
                    TextField("Description", text: $description)
                    
                    Picker("Type", selection: $type){
                        ForEach(types, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                }
                
                Section {
                    Button("Save new habit") {
                        if title != "" && description != "" {
                            let newHabit = Habit(title: title, description: description, type: type)
                            habitList.habits.append(newHabit)
                            dismiss()
                        } else {
                            hasAnyError = true
                        }
                    }
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                Button("Cancel", role: .destructive){
                    dismiss()
                }
            }
            .alert("Validation Error", isPresented: $hasAnyError){
                Button("Ok") {}
            } message: {
                Text("Title and Description are required.")
            }
        }
    }
}

struct NewHabitView_Previews: PreviewProvider {
    static let habitList: HabitList = HabitList()
    static var previews: some View {
        NewHabitView(habitList: habitList)
    }
}
