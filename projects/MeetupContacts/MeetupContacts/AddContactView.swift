//
//  AddContactView.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import SwiftUI
import CoreLocation

struct PhotoView: View {
    var uiImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var body: some View {
        VStack (alignment: .leading) {
            ZStack {
                if let photo = uiImage {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .clipShape(Circle())
                        .padding(0)
                        .overlay {
                            Circle()
                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                        }
                    
                } else {
                    ZStack {
                        Text(sourceType == .camera ? "Tap to capture photo" : "Tap to select photo")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .background(.gray)
                            .overlay {
                                Circle()
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                            }
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.top)
        }
        .padding(0)
        .padding(.bottom)
    }
}


struct AddContactView: View {
    @State private var name: String = ""
    @State private var notes: String = ""
    @State private var showingPhotoPicker = false
    @State private var uiImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
   
    @Environment(\.dismiss) var dismiss
    
    private var photoSaver = PhotoSaver()
    private let locationFetcher = LocationFetcher()
    var onSave: (_ location: CLLocationCoordinate2D, _ photoId: UUID, _ name: String, _ notes: String) -> Void
    var disableSave: Bool {
        if uiImage == nil {
            return true
        } else if name == "" {
            return true
        }
        return false
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 0) {
                
                PhotoView(uiImage: uiImage, sourceType: sourceType)
                    .onTapGesture {
                        showingPhotoPicker = true
                    }
                
                HStack (alignment: .center) {
                    
                    Spacer()
                    
                    Button {
                        sourceType = .camera
                    } label: {
                        HStack {
                            Image(systemName: "camera")
                            Text("Camera")
                        }
                    }
                    .padding()
                    .background(sourceType == .camera ? .blue : .white)
                    .foregroundColor(sourceType == .camera ? .white : .blue)
                    .cornerRadius(8)
                    .accessibilityElement()
                    .accessibilityLabel("Camera")
                    
                    Spacer()
                    
                    Button {
                        sourceType = .photoLibrary
                    } label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Photo library")
                        }
                    }
                    .padding()
                    .background(sourceType == .photoLibrary ? .blue : .white)
                    .foregroundColor(sourceType == .photoLibrary ? .white : .blue)
                    .cornerRadius(8)
                    .accessibilityElement()
                    .accessibilityLabel("Photo library")
                    
                    Spacer()
                }
                .padding()
                
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
                PhotoPicker(sourceType: sourceType) { image in
                    uiImage = image
                }
            }
            .onAppear {
                locationFetcher.start()
            }
            .onDisappear {
                locationFetcher.stop()
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
        guard let photoId = savePhoto() else {
            print("Error occurred while saving photo")
            return
        }
        guard let currentLocation = locationFetcher.lastKnownLocation else {
            print("Error occurred while getting user location")
            return
        }
        onSave(currentLocation, photoId, name, notes)
    }
    
    init(onSave: @escaping (_ location: CLLocationCoordinate2D, _ photoId: UUID, _ name: String, _ notes: String) -> Void) {
        self.onSave = onSave
    }
    
}
