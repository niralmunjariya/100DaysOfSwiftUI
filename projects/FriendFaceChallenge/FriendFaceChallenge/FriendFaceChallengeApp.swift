//
//  FriendFaceChallengeApp.swift
//  FriendFaceChallenge
//
//  Created by Niral Munjariya on 05/01/22.
//

import SwiftUI

@main
struct FriendFaceChallengeApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
