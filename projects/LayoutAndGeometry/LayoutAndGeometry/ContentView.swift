//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Niral Munjariya on 21/01/22.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<100) { index in
                    GeometryReader { geo in
                        VStack {
                            Text("\(index+1)")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hue: geo.frame(in: .global).origin.y / fullView.size.height, saturation: 1.0, brightness: 1.0))
                                .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                                .opacity(geo.frame(in: .global).origin.y <= 200 ? (geo.frame(in: .global).origin.y / 200) : 1)
                                .animation(Animation.easeOut, value: geo.frame(in: .global).origin.y)
                                .scaleEffect(getScale(y: geo.frame(in: .global).maxY, height: fullView.size.height))
                                .shadow(radius: 5)
                        }
                    }
                    .frame(height: 40)
                }
            }
        }
    }
    
    func getScale(y: Double, height: Double) -> Double {
        var scale = 1.0
        if y / height > 1.0 {
            scale = 1.0
        } else {
            scale = y / height
        }
        if scale < 0.3 {
            scale = 0.3
        }
        return scale
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
