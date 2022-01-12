//
//  PhotoSaver.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import Foundation
import SwiftUI

class PhotoSaver {
    
    func savePhoto(photo: UIImage, photoId: String){
        createFolderIfRequired()
        guard let data = photo.jpegData(compressionQuality: 0.8) else {return}
        guard let url = getURLForPhoto(photoId: photoId) else {return}
        do {
            try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Error occurred while saving contact photo")
            print(error.localizedDescription)
        }
    }
    
    func createFolderIfRequired(){
        guard let url = FileManager.default.getMeetupContactPhotosDirectory() else { return }
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error occurred while creating project folder")
                print(error.localizedDescription)
            }
        }
    }
    
    private func getURLForPhoto(photoId: String) -> URL? {
        guard let url = FileManager.default.getMeetupContactPhotosDirectory() else { return nil }
        return url.appendingPathComponent(photoId + ".jpg")
    }
    
}

