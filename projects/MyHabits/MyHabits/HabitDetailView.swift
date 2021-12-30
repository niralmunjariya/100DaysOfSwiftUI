//
//  HabitDetailView.swift
//  MyHabits
//
//  Created by Derek on 12/8/21.
//

import SwiftUI

struct HabitDetailView: View {
    @ObservedObject var habitList: HabitList
    var habit: Habit
    @State private var markAsCompleted = false
    var body: some View {
        ScrollView {
            VStack (spacing: 30) {
                
                Text(habit.title)
                    .font(.title)
                    .foregroundColor(habit.type == Habit.Good ? .green : .red)
                    .frame(maxWidth: .infinity)
                
                
                Text(habit.description)
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                
                
                HStack (spacing: 30) {
                    VStack {
                        Text(habit.type == Habit.Good ? "Started since" : "Stopping since")
                            .font(.subheadline)
                        Text(habit.formattedCreatedDate)
                            .font(.title2)
                    }
                                        
                    VStack {
                        Text("Type")
                            .font(.subheadline)
                        Text(habit.type)
                            .font(.title2)
                    }
                    
                    VStack {
                        Text(habit.type == Habit.Good ? "Completed" : "Stopped")
                            .font(.subheadline)
                        Text("\(habit.count) \(habit.count == 1 ? "time": "times")")
                            .font(.title2)
                    }
                    
                }
                
                Spacer()
                
                if markAsCompleted {
                    Text("Your progress saved successfully.")
                        .font(.title2)
                        .foregroundColor(.green)
                } else {
                    Button("Mark as \(habit.type == Habit.Bad ? "stopped" : "completed")") {
                        
                        if let habitIndex = habitList.habits.firstIndex(where : { item in
                            item.id == habit.id
                        }) {
                            print("Habit index \(habitIndex)")
                            habitList.habits[habitIndex].count += 1
                            markAsCompleted = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title)
                }
                
                
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static let habitList: HabitList = HabitList()
    static let habit: Habit = Habit(title: "Test", description: "Drink at least 5 liter of water everyday", type: Habit.Good)
    static var previews: some View {
        HabitDetailView(habitList: habitList, habit: habit)
    }
}
