//
//  ContentView.swift
//  Drawing
//
//  Created by Derek on 12/7/21.
//

import SwiftUI

struct Arrow: Shape {
    let direction: String = "Up"
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if direction == "Up"{
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY / 2))
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY / 2))
        }
        
        return path
    }
    
}

struct ContentView: View {
    @State private var thickness = 10.0
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Arrow()
                    .stroke(.red, style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
                    .frame(width: 200, height: 400)
                    .shadow(radius: 2)
                    .padding()
                
                Spacer()
                
                VStack(alignment: .leading) {
                    
                    Text("Line Thickness: \(thickness, format: .number.precision(.fractionLength(0)))")
                        .font(.title2.bold())
                    Slider(value: $thickness, in: 10...50, step: 1)
                        .animation(.default, value: thickness)
                }
                .padding()
            }
            .navigationTitle("Drawing")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
