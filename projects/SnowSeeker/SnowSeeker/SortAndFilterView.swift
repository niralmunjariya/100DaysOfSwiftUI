//
//  FilterOptionsView.swift
//  SnowSeeker
//
//  Created by Niral Munjariya on 26/01/22.
//

import SwiftUI

extension Set {
    func toArray() -> [Element] {
        return Array(self)
    }
}

struct SortAndFilterView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var sortField: SortOption.RawValue
    @Binding var sortOrder: SortOrder.RawValue
    @Binding var filterField: String
    @Binding var filterValue: String
    @Binding var showOnlyFavorites: Bool
    
    let countries: Set<String>
    let sizes: Set<Int>
    let prices: Set<Int>
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sort Options") {
                    Picker("By", selection: $sortField) {
                        ForEach(SortOption.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Order", selection: $sortOrder) {
                        ForEach(SortOrder.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Filter Options") {
                    VStack {
                        Picker("By", selection: $filterField) {
                            ForEach(FilterOption.allCases) { item in
                                Text(item.rawValue != "" ? item.rawValue : "None")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                if filterField == FilterOption.country.rawValue {
                    Section {
                        Picker("Country", selection: $filterValue) {
                            Text("All")
                                .tag("")
                            ForEach(countries.toArray(), id: \.self) { country in
                                Text(country)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                if filterField == FilterOption.size.rawValue {
                    Section {
                        Picker("Size", selection: $filterValue) {
                            Text("All")
                                .tag("")
                            ForEach(sizes.toArray(), id: \.self) { size in
                                if size == 1 {
                                    Text("Small")
                                        .tag("\(size)")
                                } else if size == 2 {
                                    Text("Average")
                                        .tag("\(size)")
                                } else if size > 2 {
                                    Text("Large")
                                        .tag("\(size)")
                                }
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                if filterField == FilterOption.price.rawValue {
                    Section {
                        Picker("Price", selection: $filterValue) {
                            Text("All")
                                .tag("")
                            ForEach(prices.toArray(), id: \.self) { price in
                                Text(String(repeating: "$", count: price))
                                    .tag("\(price)")
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                
                Section() {
                    Toggle("Show favorites only", isOn: $showOnlyFavorites)
                }
                
            }
            .navigationTitle("Sort & Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
