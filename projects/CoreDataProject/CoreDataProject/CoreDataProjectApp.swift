//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Niral Munjariya on 04/01/22.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
