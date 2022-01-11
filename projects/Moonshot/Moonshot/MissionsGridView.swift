//
//  MissionsGridView.swift
//  Moonshot
//
//  Created by Derek on 12/7/21.
//

import SwiftUI

struct MissionsGridView: View {
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(missions) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
                } label: {
                    VStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                            .accessibilityElement()

                        VStack {
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundColor(.white)

                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.lightBackground)
                        .accessibilityElement()
                        .accessibilityLabel("Mission \(mission.displayName) launched on \(mission.formattedLaunchDate)")
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBackground)
                    )
                    
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct MissionsGridView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionsGridView(missions: missions, astronauts: astronauts)
    }
}
