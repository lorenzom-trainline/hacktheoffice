//
//  OfficeUpdateData.swift
//  Beacoffice
//
//  Created by Oriol Ganduxe Pregona on 31/3/22.
//

import Foundation

struct OfficeUpdateData {
    let title: String
    let body: String
    let officeName: String
    
    static func createFrom(dict: [String: String]) -> OfficeUpdateData? {
        
        if let title = dict["title"],
           let body = dict["body"],
           let officeName = dict["officeName"] {
            
            return OfficeUpdateData(title: title,
                                    body: body,
                                    officeName: officeName)
        } else {
            return nil
        }
    }
}
