//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Niral Munjariya on 24/01/22.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var showingSortAndFilterView = false
    
    @StateObject var favorites = Favorites()
    @State private var searchText = ""
    
    @State private var sortField: SortOption.RawValue = SortOption.name.rawValue
    @State private var sortOrder: SortOrder.RawValue = SortOrder.asc.rawValue
    @State private var filterField: FilterOption.RawValue = FilterOption.none.rawValue
    @State private var filterValue: String = ""
    @State private var showFavoritesOnly: Bool = false
    
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack (alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            .sheet(isPresented: $showingSortAndFilterView) {
                SortAndFilterView(sortField: $sortField, sortOrder: $sortOrder, filterField: $filterField, filterValue: $filterValue, showOnlyFavorites: $showFavoritesOnly, countries: countries, sizes: sizes, prices: prices)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sort & Filter") {
                        showingSortAndFilterView = true
                    }
                }
            }
            .onChange(of: filterField) { _ in
                filterValue = ""
            }
            WelcomeView()
        }
        .environmentObject(favorites)
    }
    
    var filteredResorts: [Resort] {
        var filteredResorts = resorts
        
        // Filtering
        if !filterField.isEmpty && !filterValue.isEmpty {
            switch filterField {
            case FilterOption.country.rawValue:
                filteredResorts = filteredResorts.filter { $0.country == filterValue }
            case FilterOption.size.rawValue:
                filteredResorts = filteredResorts.filter { $0.size == Int(filterValue) }
            case FilterOption.price.rawValue:
                filteredResorts = filteredResorts.filter { $0.price == Int(filterValue) }
            default:
                filteredResorts = resorts
            }
        }
        
        if showFavoritesOnly {
            filteredResorts = filteredResorts.filter{ resort in
                favorites.contains(resort)
            }
        }
        
        // Sorting
        if !sortField.isEmpty && !sortOrder.isEmpty {
            switch sortField {
            case SortOption.country.rawValue:
                if sortOrder == SortOrder.asc.rawValue {
                    filteredResorts = filteredResorts.sorted(by: { $0.country < $1.country })
                } else {
                    filteredResorts = filteredResorts.sorted(by: { $0.country > $1.country })
                }
            default:
                if sortOrder == SortOrder.asc.rawValue {
                    filteredResorts = filteredResorts.sorted(by: { $0.name < $1.name })
                } else {
                    filteredResorts = filteredResorts.sorted(by: { $0.name > $1.name })
                }
            }
        }
        
        // Searching
        if !searchText.isEmpty {
            filteredResorts = filteredResorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filteredResorts
    }
    
    var countries: Set<String> {
        var countries = Set<String>()
        for resort in resorts {
            countries.insert(resort.country)
        }
        return countries
    }
    
    var sizes: Set<Int> {
        var sizes = Set<Int>()
        for resort in resorts {
            sizes.insert(resort.size)
        }
        return sizes
    }
    
    var prices: Set<Int> {
        var prices = Set<Int>()
        for resort in resorts {
            prices.insert(resort.price)
        }
        return prices
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
