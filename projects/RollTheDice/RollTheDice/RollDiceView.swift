//
//  RollDiceView.swift
//  RollTheDice
//
//  Created by Niral Munjariya on 21/01/22.
//

import SwiftUI

struct RollDiceView: View {
    @EnvironmentObject var vm: DiceViewModel
    let threeColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                if vm.dice.count > 0 {
                    HStack {
                        if vm.numberOfDice < 4 {
                            VStack (spacing: 40) {
                                ForEach(vm.dice) { die in
                                    SingleDiceView(face: die.value, size: 100)
                                        .frame(width: 100, height: 100)
                                        .accessibilityElement()
                                        .accessibilityLabel("\(die.sides)-sided die with face \(die.value)")
                                }
                            }
                        } else {
                            LazyVGrid(columns: threeColumns, spacing: 40) {
                                ForEach(vm.dice) { die in
                                    SingleDiceView(face: die.value, size: 80)
                                        .frame(width: 80, height: 80)
                                        .accessibilityLabel("\(die.sides)-sided die with face \(die.value)")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                Button("Roll") {
                    vm.onRollDice()
                }
                .font(.title2)
                .frame(width: 200, height: 44)
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(Capsule())
                
                Spacer()
                
                Text("\(vm.rollTotal > 0 ? "Roll Total: \(vm.rollTotal)" : "")")
                    .font(.title2)
                    .accessibilityLabel("Roll total is \(vm.rollTotal)")
                
                Spacer()
            }
            .navigationTitle("Roll The Dice")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        SingleDiceView(face: 3, size: 20)
                            .foregroundColor(.blue)
                            .accessibilityHidden(true)
                        
                        Picker("Number of Sides", selection: $vm.numberOfSides) {
                            ForEach(vm.diceSides, id: \.self) { type in
                                Text("\(type)-sided")
                            }
                        }
                        .onChange(of: vm.numberOfSides) { _ in
                            vm.generateDice()
                        }
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "number.square")
                            .foregroundColor(.blue)
                            .accessibilityHidden(true)
                        
                        Picker("Number of Dice", selection: $vm.numberOfDice) {
                            ForEach(1..<11, id: \.self) { number in
                                Text("\(number) \(number == 1 ? "die" : "dice")")
                            }
                        }
                        .onChange(of: vm.numberOfDice) { _ in
                            vm.generateDice()
                        }
                    }
                }
            }
        }
    }
    
    init() { }
}

