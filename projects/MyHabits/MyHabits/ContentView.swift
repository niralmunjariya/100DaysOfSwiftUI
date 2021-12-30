//
//  ContentView.swift
//  MyHabits
//
//  Created by Derek on 12/8/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habitList = HabitList()
    @State private var showingNewHabitView = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        Group {
                            ForEach(habitList.goodHabits){ habit in
                                NavigationLink {
                                    HabitDetailView(habitList: habitList, habit: habit)
                                } label: {
                                    HStack {
                                        VStack (alignment: .leading, spacing: 5) {
                                            Text(habit.title)
                                                .font(.title3)
                                                .foregroundColor(habit.type == Habit.Bad ? .red : .green)
                                            
                                            Text(habit.description)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            
                                        }
                                        Spacer()
                                        Text("\(habit.count)")
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                let originalIndexSet = getOriginalIndexSet(of: indexSet, habits: habitList.goodHabits)
                                removeHabits(at: originalIndexSet)
                            }
                        }
                    } header: {
                        Text(Habit.Good)
                            .font(.title3.bold())
                            .foregroundColor(.blue)
                    }
                    
                    Section {
                        Group {
                            ForEach(habitList.badHabits){ habit in
                                NavigationLink {
                                    HabitDetailView(habitList: habitList, habit: habit)
                                } label: {
                                    HStack {
                                        VStack (alignment: .leading, spacing: 5) {
                                            Text(habit.title)
                                                .font(.title3)
                                                .foregroundColor(habit.type == Habit.Bad ? .red : .green)
                                            
                                            Text(habit.description)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            
                                        }
                                        Spacer()
                                        Text("\(habit.count)")
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                let originalIndexSet = getOriginalIndexSet(of: indexSet, habits: habitList.badHabits)
                                removeHabits(at: originalIndexSet)
                            }
                        }
                    }header: {
                        Text(Habit.Bad)
                            .font(.title3.bold())
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("MyHabits")
            .toolbar {
                Button {
                    showingNewHabitView.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("New")
                    }
                }
            }
            .sheet(isPresented: $showingNewHabitView){
                NewHabitView(habitList: habitList)
            }
        }
    }
    
    func removeHabits(at offsets: IndexSet){
        habitList.habits.remove(atOffsets: offsets)
    }
    
    func getOriginalIndexSet(of indexSet: IndexSet, habits: [Habit]) -> IndexSet {
        var set = IndexSet()
        indexSet.forEach{ index in
            let listItem = habits[index];
            let itemIndex = habitList.habits.firstIndex(where: { $0.id == listItem.id }) ?? 0
            if itemIndex >= 0 {
                set.insert(itemIndex)
            }
        }
        return set
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
