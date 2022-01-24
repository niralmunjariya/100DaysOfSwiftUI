//
//  ContentView.swift
//  RollTheDice
//
//  Created by Niral Munjariya on 21/01/22.
//

import SwiftUI

enum DieType: Int {
    case fourSided = 4
    case sixSided = 6
    case eightSided = 8
    case tenSided = 10
    case twelveSided = 12
    case twentySided = 20
    case hundredSided = 100
}

struct ContentView: View {
    
    @StateObject var diceViewModel = DiceViewModel()
    
    var body: some View {
        TabView {
            RollDiceView()
                .tabItem {
                    Label("Roll The Dice", systemImage: "die.face.3")
                }
                .environmentObject(diceViewModel)
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .environmentObject(diceViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
