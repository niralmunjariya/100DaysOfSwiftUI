//
//  EditView.swift
//  MyBucketList
//
//  Created by Niral Munjariya on 10/01/22.
//

import SwiftUI

struct EditView: View {    
    @StateObject private var viewModel: EditViewModel
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    var onDelete: (Location) -> Void
    
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextEditor(text: $viewModel.description)
                }
                
                Section("Nearby Places") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) {page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
                
            }
            .navigationTitle("Place details")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete", role: .destructive) {
                        showingDeleteConfirmation = true
                    }
                }
                                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var newLocation = viewModel.location
                        newLocation.id = UUID()
                        newLocation.name = viewModel.name
                        newLocation.description = viewModel.description
                        onSave(newLocation)
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
            .confirmationDialog("Are you sure?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible){
                Button("Delete", role: .destructive){
                    let locationToDelete = viewModel.location
                    onDelete(locationToDelete)
                    dismiss()
                }
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void) {
        self.onSave = onSave
        self.onDelete = onDelete
        _viewModel = StateObject(wrappedValue: EditViewModel(location: location))
    }
    
}
