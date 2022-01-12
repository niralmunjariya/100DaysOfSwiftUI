//
//  ContentView-ViewModel.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import Foundation
import SwiftUI

extension ContentView {
    @MainActor class ContentViewModel: ObservableObject {
        @Published var showingAddView = false
        @Published var showingPhotoPicker = false
        
        init() {
            
        }
    }
}
