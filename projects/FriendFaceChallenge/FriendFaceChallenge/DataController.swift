//
//  DataController.swift
//  FriendFaceChallenge
//
//  Created by Niral Munjariya on 06/01/22.
//

import CoreData
import Foundation

@MainActor
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FriendFace")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load \(error.localizedDescription)")
            }
        }
    }
}
