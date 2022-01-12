//
//  MeetupContact+CoreDataProperties.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//
//

import Foundation
import CoreData


extension MeetupContact {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeetupContact> {
        return NSFetchRequest<MeetupContact>(entityName: "MeetupContact")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var photoId: UUID?
    
    
    var wrappedName: String {
        name ?? "Unknown Contact"
    }
    
    var wrappedNotes: String {
        notes ?? "No notes"
    }
    
    var wrappedPhoto: URL? {
        if photoId != nil {
            if let uuidString = photoId?.uuidString {
                guard let url = FileManager.default.getMeetupContactPhotosDirectory()?.appendingPathComponent(uuidString + ".jpg") else { return nil }
                return url
            }
        }
        return nil
    }
    
}

extension MeetupContact : Identifiable {
    
}
