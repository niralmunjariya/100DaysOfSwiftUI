//
//  MeetupContact+CoreDataClass.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 13/01/22.
//
//

import Foundation
import CoreData

@objc(MeetupContact)
public class MeetupContact: NSManagedObject, Comparable {
    
    public static func < (lhs: MeetupContact, rhs: MeetupContact) -> Bool {
        lhs.wrappedName < rhs.wrappedName
    }
    
}
