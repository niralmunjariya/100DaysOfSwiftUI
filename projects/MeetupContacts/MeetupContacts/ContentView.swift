//
//  ContentView.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject private var viewModel = ContentViewModel()
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.name)
        ]
    , predicate: nil) var contacts: FetchedResults<MeetupContact>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(contacts ){ contact in
                        NavigationLink {
                            DetailView(contact: contact)
                        } label: {
                            HStack (spacing: 15) {
                                AsyncImage(url: contact.wrappedPhoto) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                } placeholder: {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(maxWidth: 60,  maxHeight: 50)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                                }
                                .padding(0)
                                
                                VStack (alignment: .leading) {
                                    Text(contact.wrappedName)
                                        .font(.title3)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteContact)
                }
            }
            .navigationTitle("Meetup Contacts")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showingAddView = true
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                            Text("New")
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddView){
                AddContactView { location, photoId, name, notes in
                    addContact(location: location, photoId: photoId, name: name, notes: notes)
                }
            }
        }
    }
    
    func addContact(location: CLLocationCoordinate2D, photoId: UUID, name: String, notes: String) {
        let newContact = MeetupContact(context: moc)
        newContact.id = UUID()
        newContact.photoId = photoId
        newContact.latitude = location.latitude
        newContact.longitude = location.longitude
        newContact.name = name
        newContact.notes = notes
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Error occurred while saving contact")
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteContact(at offsets: IndexSet){
        for offset in offsets {
            let contact = contacts[offset]
            moc.delete(contact)
        }
        if moc.hasChanges {
            try? moc.save()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
