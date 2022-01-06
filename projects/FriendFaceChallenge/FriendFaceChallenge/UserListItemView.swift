//
//  UserListItemView.swift
//  FriendFaceChallenge
//
//  Created by Niral Munjariya on 05/01/22.
//

import SwiftUI

struct UserListItemView: View {
    let user: CachedUser
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Rectangle()
                        .fill(user.isActive ? .green : .gray)
                        .frame(width: 4, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .opacity(0.8)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    
                    VStack (alignment: .leading, spacing: 4) {
                        Text(user.wrappedName)
                            .font(.headline)
                        
                        Text("\(user.age) Years")
                            .font(.caption)
                    }
                }
            }
        }
    }
}
