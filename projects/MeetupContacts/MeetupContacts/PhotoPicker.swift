//
//  PhotoPicker.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var onSelected: (_ photo: UIImage) -> Void
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: PhotoPicker
        
        init (_ parent: PhotoPicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            
            if let photo = info[.originalImage] as? UIImage {
                self.parent.onSelected(photo)
            }
        }

    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if self.sourceType == .camera && isCameraAvailable(){
            picker.sourceType = self.sourceType
        } else {
            print("Fallback to photos library because camera is not availalbe on this device.")
            picker.sourceType = .photoLibrary
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func isCameraAvailable() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        }
        return false
    }
}

