//
//  Expenses.swift
//  iExpense
//
//  Created by Derek on 12/6/21.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "ExpenseItems")
            }
        }
    }
    
    var personalExpenses: [ExpenseItem] {
        return items.filter{ item in
            item.type == "Personal"
        }
    }
    
    var businessExpenses: [ExpenseItem] {
        return items.filter{ item in
            item.type == "Business"
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "ExpenseItems"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        items = []
    }
}
