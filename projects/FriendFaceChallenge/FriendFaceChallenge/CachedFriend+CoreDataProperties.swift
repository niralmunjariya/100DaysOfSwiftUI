//
//  CachedFriend+CoreDataProperties.swift
//  FriendFaceChallenge
//
//  Created by Niral Munjariya on 06/01/22.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    
    var wrappedName: String {
        return name ?? "Unknown Name"
    }

}

extension CachedFriend : Identifiable {

}
