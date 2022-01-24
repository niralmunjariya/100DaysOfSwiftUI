//
//  HistoryView.swift
//  RollTheDice
//
//  Created by Niral Munjariya on 21/01/22.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var vm: DiceViewModel
    
    var body: some View {
        NavigationView {
            List(vm.history) { historyItem in
                VStack {
                    HStack {
                        VStack (alignment: .leading, spacing: 5) {
                            HStack {
                                SingleDiceView(face: historyItem.sides, size: 30)
                                Text("x")
                                    .padding([.leading, .trailing], 4)
                                Text("\(historyItem.dice.count)")
                                    .fontWeight(.bold)
                                Text("\(historyItem.dice.count == 1 ? "die" : "dice")")
                            }
                            .accessibilityElement()
                            .accessibilityLabel("Rolled \(historyItem.dice.count) \(historyItem.sides)-sided \(historyItem.dice.count == 1 ? "die" : "dice")")
                            
                            Text("\(historyItem.date.formatted(date: .abbreviated, time: .shortened))")
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(historyItem.total)")
                            .font(.title2)
                            .accessibilityLabel("Roll total is \(historyItem.total)")
                    }
                }
                .padding(.top, 4)
                
            }
            .navigationTitle("History")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
