//
//  RollTheDiceApp.swift
//  RollTheDice
//
//  Created by Niral Munjariya on 21/01/22.
//

import SwiftUI

@main
struct RollTheDiceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}
