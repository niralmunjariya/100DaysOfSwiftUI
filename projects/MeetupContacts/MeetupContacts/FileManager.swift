//
//  FileManager.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import Foundation

extension FileManager {
    
    /**
     * Saving photos to documents directory because somehow I am not able to save photos to photos directory, it shows no permission to save to photos library
     */
    func getMeetupContactPhotosDirectory() -> URL? {
        guard let path = self.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return path.appendingPathComponent("MeetupContacts")
    }
    
}
