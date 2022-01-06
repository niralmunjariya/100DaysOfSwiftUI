//
//  User.swift
//  FriendFaceChallenge
//
//  Created by Niral Munjariya on 05/01/22.
//

import Foundation



struct User: Codable {
    
    struct Friend: Codable {
        var id: UUID
        var name: String
    }
    
    enum CodingKeys: CodingKey{
        case id, isActive, name, age, company, email, address, about, registered, tags, friends
    }
    
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let tags: [String]
    let registered: Date
    let friends: [Friend]
    
    var commaSeparatedTags: String {
        tags.joined(separator: ", ")
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(company, forKey: .company)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
        try container.encode(about, forKey: .about)
        try container.encode(tags, forKey: .tags)
        try container.encode(friends, forKey: .friends)
        try container.encode(registered, forKey: .registered)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        company = try container.decode(String.self, forKey: .company)
        email = try container.decode(String.self, forKey: .email)
        address = try container.decode(String.self, forKey: .address)
        about = try container.decode(String.self, forKey: .about)
        tags = try container.decode([String].self, forKey: .tags)
        friends = try container.decode([Friend].self, forKey: .friends)
        registered = try container.decode(Date.self, forKey: .registered)
    }
}
