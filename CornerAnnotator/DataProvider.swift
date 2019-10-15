//
//  DataProvider.swift
//  CornerAnnotator
//
//  Created by Magnus Jensen on 15/10/2019.
//  Copyright © 2019 Magnus Jensen. All rights reserved.
//

import Foundation

struct DataProvider {
    
    typealias FilePoints = [String: Points]
    
    private let jsonFile = "/points.json"
    private let directory: String
    
    private var data: FilePoints
    
    init(directory: String) {
        
        self.directory = directory
        
        if let data = try? Data(referencing: NSData(contentsOfFile: directory + jsonFile)) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(FilePoints.self, from: data) {
                print("did recover!")
                self.data = decoded
            } else {
                self.data = [:]
            }
        } else {
            self.data = [:]
        }
    }
    
    func points(for file: String) -> Points? {
        print("did return points")
        print(data)
        return data[file]
    }
    
    mutating func setPoints(_ points: Points, forFile file: String) {
        data[file] = points
        print("Did set points")
        save()
    }
    
    mutating func resetPoints(for file: String) {
        print("did reset")
        data.removeValue(forKey: file)
        save()
    }
    
    private func save() {
        print("beginning to save")
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self.data) {
            NSData(data: data).write(toFile: directory + jsonFile, atomically: true)
        }
    }
}

struct Points: Codable {
    let nv: CGPoint
    let ne: CGPoint
    let se: CGPoint
    let sv: CGPoint
}


