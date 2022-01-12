//
//  DetailView.swift
//  MeetupContacts
//
//  Created by Niral Munjariya on 12/01/22.
//

import SwiftUI

struct DetailView: View {
    var contact: MeetupContact
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                ZStack {
                    if contact.wrappedPhoto != nil {
                        AsyncImage(url: contact.wrappedPhoto) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Rectangle()
                            .scaledToFit()
                            .background(.gray)
                        
                        Text("Unable to load photo")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 300)
                
                
                VStack (alignment: .leading) {
                    
                    Text(contact.wrappedName)
                        .font(.title)
                    
                    Spacer()
                    
                    Text(contact.wrappedNotes)
                        .font(.subheadline)
                }
                .padding()
            }
            .navigationTitle(contact.wrappedName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
