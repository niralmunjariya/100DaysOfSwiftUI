//
//  AddContactView.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import SwiftUI

struct AddContactView: View {
    @State private var name: String = ""
    @State private var notes: String = ""
    @Environment(\.dismiss) var dismiss
    
    private var photoSaver = PhotoSaver()
    
    @State private var showingPhotoPicker = false
    @State private var uiImage: UIImage?
    
    var disableSave: Bool {
        if uiImage == nil {
            return true
        } else if name == "" {
            return true
        }
        return false
    }
    
    
    var onSave: (_ photoId: UUID, _ name: String, _ notes: String) -> Void
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    ZStack {
                        if let photo = uiImage {
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 250)
                                .cornerRadius(8)
                                .padding(0)
                                
                        } else {
                            ZStack {
                                Text("Select a photo")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, maxHeight: 250)
                            }
                            .background(.gray)
                        }
                    }
                    .padding(.top)
                    .onTapGesture {
                        showingPhotoPicker = true
                    }
                }
                .padding(0)
                
                Form {
                    Section("Name") {
                        TextField("", text: $name)
                            .labelsHidden()
                            .accessibilityLabel("Name")
                    }
                    Section("Notes") {
                        TextEditor(text: $notes)
                            .accessibilityLabel("Notes")
                    }
                }
            }
            .navigationTitle("Add new contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveContact()
                        dismiss()
                    }
                    .disabled(disableSave)
                }
            }
            .sheet(isPresented: $showingPhotoPicker){
                PhotoPicker(onSelected: ({image in
                    uiImage = image
                }))
            }
        }
    }
    
    func savePhoto() -> UUID? {
        guard let contactPhoto = uiImage else { return nil }
        let photoId = UUID()
        photoSaver.savePhoto(photo: contactPhoto, photoId: photoId.uuidString)
        return photoId
    }
    
    func saveContact() {
        if let photoId = savePhoto() {
            onSave(photoId, name, notes)
        } else {
            print("Error occurred while saving photo")
            print("Unable to save contact")
        }
    }
    
    init(onSave: @escaping (_ photoId: UUID, _ name: String, _ notes: String) -> Void) {
        self.onSave = onSave
    }
    
}
