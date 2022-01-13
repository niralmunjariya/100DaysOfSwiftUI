//
//  DetailView.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import SwiftUI
import MapKit

struct DetailView: View {
    var contact: MeetupContact
    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: -0.146), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                VStack (alignment: .center) {
                    ZStack {
                        if contact.wrappedPhoto != nil {
                            AsyncImage(url: contact.wrappedPhoto) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                            }
                            .frame(height: 200)
                        } else {
                            Rectangle()
                                .scaledToFit()
                                .background(.gray)
                            
                            Text("Unable to load photo")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .frame(maxWidth: .infinity)
                
                VStack (alignment: .leading) {
                    Text(contact.wrappedNotes)
                }
                .padding()
                
                VStack {
                    Map(coordinateRegion: $mapRegion, annotationItems: [contact]) { item in
                        MapAnnotation(coordinate: item.coordinate) {
                            VStack {
                                AsyncImage(url: item.wrappedPhoto) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .overlay {
                                            Circle()
                                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                                        }
                                        .frame(width: 60, height: 60)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                Text(contact.wrappedName)
                                    .shadow(radius: 20)
                                    .font(.caption)
                                    .fixedSize()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                }
            }
            .navigationTitle(contact.wrappedName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    init (contact: MeetupContact) {
        self.contact = contact
        _mapRegion = State(wrappedValue: contact.mapRegion)
    }
}
