//
//  ContentView.swift
//  Moonshot
//
//  Created by Derek on 12/7/21.
//

import SwiftUI

enum ViewMode {
    case grid, list
}

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var viewMode: ViewMode = .list
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            Group {
                if viewMode == .grid {
                    ScrollView {
                        MissionsGridView(missions: missions, astronauts: astronauts)
                    }
                    .navigationTitle("Moonshot")
                    .background(.darkBackground)
                    .preferredColorScheme(.dark)
                } else {
                    Group {
                        MissionsListView(missions: missions, astronauts: astronauts)
                    }
                    .navigationTitle("Moonshot")
                    .background(.darkBackground)
                    .preferredColorScheme(.dark)
                }
            }
            .toolbar{
                Button {
                    if viewMode == .grid {
                        viewMode = .list
                    } else {
                        viewMode = .grid
                    }
                } label: {
                    HStack {
                        Image(systemName: viewMode == .list ? "circle.grid.2x2" : "list.bullet")
                        Text(viewMode == .list ? "Grid" : "List")
                    }
                    
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
