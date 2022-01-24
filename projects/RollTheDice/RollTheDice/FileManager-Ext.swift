//
//  FileManager-Ext.swift
//  RollTheDice
//
//  Created by Niral Munjariya on 24/01/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
