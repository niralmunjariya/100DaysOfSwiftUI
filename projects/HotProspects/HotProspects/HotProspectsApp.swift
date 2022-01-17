//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Niral Munjariya on 13/01/22.
//

import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}
