//
//  ContentView.swift
//  iExpense
//
//  Created by Derek on 12/6/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            
            VStack (spacing: 0) {
                List {
                    
                    Section(header: Text("Personal expenses")) {
                        ForEach(expenses.personalExpenses, id: \.id){ item in
                            HStack {
                                Text(item.name)
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                    .foregroundColor(getStyleColor(item.amount))
                            }
                        }
                        .onDelete { indexSet in
                            let originalIndexSet = getOriginalIndexSet(of: indexSet, items: expenses.personalExpenses)
                            removeItems(at: originalIndexSet)
                        }
                    }
                    
                    Section(header: Text("Business expenses")) {
                        ForEach(expenses.businessExpenses, id: \.id){ item in
                            HStack {
                                Text(item.name)
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                    .foregroundColor(getStyleColor(item.amount))
                            }
                        }
                        .onDelete { indexSet in
                            let originalIndexSet = getOriginalIndexSet(of: indexSet, items: expenses.businessExpenses)
                            removeItems(at: originalIndexSet)
                        }
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("New expense")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
    
    func getStyleColor(_ amount: Double) -> Color{
        if(amount > 100){
            return Color.red
        } else if amount > 10 {
            return Color.orange
        } else {
            return Color.black
        }
    }
    
    func getOriginalIndexSet(of indexSet: IndexSet, items: [ExpenseItem]) -> IndexSet {
        var set = IndexSet()
        indexSet.forEach{ index in
            let listItem = items[index];
            let itemIndex = expenses.items.firstIndex(where: { $0.id == listItem.id }) ?? 0
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
