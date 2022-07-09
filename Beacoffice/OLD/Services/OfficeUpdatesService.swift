//
//  OfficeUpdatesService.swift
//  Beacoffice
//
//  Created by Oriol Ganduxe Pregona on 31/3/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum OfficeUpdatesError: Error {

    case unexpectedData
    case missingMajorMinorKey
    case missingDocument
}

typealias OfficeUpdatesClosure = (Result<OfficeUpdateData, OfficeUpdatesError>) -> Void

protocol OfficeUpdatesService {
    
    func fetchOfficeInfo(major: Int, minor: Int, completion: @escaping OfficeUpdatesClosure)
}

class OfficeUpdatesFirebaseService: OfficeUpdatesService {
    
    private let db: Firestore
    
    init() {
        FirebaseApp.configure()
        self.db = Firestore.firestore()
    }
    
    func fetchOfficeInfo(major: Int, minor: Int, completion: @escaping OfficeUpdatesClosure) {

        let key = "\(major).\(minor)"
        
        let docRef = db.collection("office").document("ios")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                 // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                if let dict = document.data()?[key] as? [String: String] {
                   
                    if let data = OfficeUpdateData.createFrom(dict: dict) {
                        completion(.success(data))
                    } else {
                        completion(.failure(.unexpectedData))
                    }
                                   
                } else {
                    completion(.failure(.missingMajorMinorKey))
                }
            } else {
            
                completion(.failure(.missingDocument))
            }
        }
        
    }
}
