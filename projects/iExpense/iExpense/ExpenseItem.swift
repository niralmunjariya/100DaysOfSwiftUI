//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Derek on 12/6/21.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
