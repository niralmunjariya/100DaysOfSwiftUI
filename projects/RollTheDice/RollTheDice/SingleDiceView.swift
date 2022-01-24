//
//  SingleDiceView.swift
//  RollTheDice
//
//  Created by Niral Munjariya on 21/01/22.
//

import SwiftUI

struct SingleDiceView: View {
    var face: Int = Int.random(in: 1...6)
    var size: CGFloat = 44
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if face <= 6 {
            Image(systemName: "die.face.\(face)")
                .resizable()
                .frame(width: size, height: size)
        } else {
            Text("\(face)")
                .font(.system(size: size / 2.25))
                .fontWeight(.semibold)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: size / 12)
                )
        }
    }
}

struct SingleDiceView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDiceView()
    }
}
