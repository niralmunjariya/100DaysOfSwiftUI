//
//  Welcome.swift
//  SnowSeeker
//
//  Created by Niral Munjariya on 24/01/22.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to Snowseeker!")
                .font(.largeTitle)
            
            Text("Please select a resort from the left-hand menu: swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
        
    }
}
