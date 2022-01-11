//
//  MissionsListView.swift
//  Moonshot
//
//  Created by Derek on 12/7/21.
//

import SwiftUI

struct MissionsListView: View {
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    var body: some View {
        VStack {
            List(missions) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
                } label : {
                    HStack (spacing: 20) {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                        
                        VStack (alignment: .leading, spacing: 10) {
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundColor(.white)

                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                    }
                    .accessibilityElement()
                    .accessibilityLabel("Mission \(mission.displayName) launched on \(mission.formattedLaunchDate)")
                }
                .listRowBackground(Color.darkBackground)
                
            }
            .listStyle(.plain)
        }
    }
}

struct MissionsListView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionsListView(missions: missions, astronauts: astronauts)
    }
}
