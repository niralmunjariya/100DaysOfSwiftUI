//
//  FileManager-Ext.swift
//  SnowSeeker
//
//  Created by Niral Munjariya on 26/01/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
