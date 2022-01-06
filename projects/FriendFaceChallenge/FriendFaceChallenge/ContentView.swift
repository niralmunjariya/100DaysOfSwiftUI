//
//  ContentView.swift
//  FriendFaceChallenge
//
//  Created by Niral Munjariya on 05/01/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
        SortDescriptor(\.age)
    ]) var users: FetchedResults<CachedUser>
    
    var body: some View {
        NavigationView {
            List(users, id: \.id) { user in
                NavigationLink {
                    UserDetailView(user: user)
                } label: {
                    UserListItemView(user: user)
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
            .listStyle(.automatic)
            .task {
                if(users.count == 0){
                    let users = await getUsersFromServer()
                    if let users = users {
                        await loadUsersToCache(users: users)
                    }
                }
            }
            .navigationTitle("FriendFace")
        }
    }
    
    func getUsersFromServer() async -> [User]? {
        // Fetching data every time
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decodedResponse = try? decoder.decode([User].self, from: data) {
                let fetchedUsers: [User] = decodedResponse
                return fetchedUsers
            }
            return nil
        } catch {
            print("Invalid data")
        }
        return nil
    }
    
    func loadUsersToCache(users: [User]?) async -> Void {
        await MainActor.run {
            if let users = users {
                for user in users {
                    let cachedUser = CachedUser(context: moc)
                    cachedUser.id = user.id;
                    cachedUser.name = user.name
                    cachedUser.isActive = user.isActive
                    cachedUser.age = Int16(user.age)
                    cachedUser.email = user.email
                    cachedUser.about = user.about
                    cachedUser.address = user.address
                    cachedUser.company = user.company
                    cachedUser.tags = user.tags.joined(separator: ",")
                    cachedUser.registered = user.registered
                    for friend in user.friends {
                        let cachedFriend = CachedFriend(context: moc)
                        cachedFriend.id = friend.id
                        cachedFriend.name = friend.name
                        cachedUser.addToFriends(cachedFriend)
                    }
                }
                
                if moc.hasChanges {
                    try? moc.save()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
