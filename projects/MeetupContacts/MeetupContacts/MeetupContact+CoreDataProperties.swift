//
//  MeetupContact+CoreDataProperties.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 13/01/22.
//
//

import Foundation
import CoreData
import CoreLocation
import MapKit

extension MeetupContact {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeetupContact> {
        return NSFetchRequest<MeetupContact>(entityName: "MeetupContact")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var photoId: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    
    
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
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var mapRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    }
    
}

extension MeetupContact : Identifiable {
    
}
