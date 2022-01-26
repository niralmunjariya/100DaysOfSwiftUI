//
//  Resort.swift
//  SnowSeeker
//
//  Created by Niral Munjariya on 24/01/22.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
   
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts.randomElement()!
    
}

enum FilterOption: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case none = ""
    case country = "Country"
    case size = "Size"
    case price = "Price"
}

enum SortOrder: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case asc = "Asc"
    case desc = "Desc"
}

enum SortOption: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case name = "Name"
    case country = "Country"
}
