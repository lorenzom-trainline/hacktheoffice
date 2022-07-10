//
//  Event.swift
//  Beacoffice
//
//  Created by Oriol Ganduxe Pregona on 31/3/22.
//

import Foundation

struct Office: Equatable {
    let id: String
    let name: String
}

struct BeaconId: Equatable {
    let major: Int
    let minor: Int
    
    var version: String {
        "\(major).\(minor)"
    }
}

struct Beacon: Equatable {
    let office: Office
    let id: BeaconId
    let name: String
}

struct Event: Equatable {

    let beacon: Beacon? // TODO
    
    let title: String
    let body: String
    let officeName: String
    
    static func createFrom(dict: [String: String]) -> Event? {
        
        if let title = dict["title"],
           let body = dict["body"],
           let officeName = dict["officeName"] {
            
            return Event(beacon: nil,
                         title: title,
                         body: body,
                         officeName: officeName)
        }
        return nil
    }
}
