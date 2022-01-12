//
//  FileManager.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import Foundation

extension FileManager {
    
    func getMeetupContactPhotosDirectory() -> URL? {
        guard let path = self.urls(for: .picturesDirectory, in: .userDomainMask).first else { return nil }
        return path.appendingPathComponent("MeetupContacts")
    }
    
}
