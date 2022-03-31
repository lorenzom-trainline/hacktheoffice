//
//  OfficeUpdatesService.swift
//  Beacoffice
//
//  Created by Oriol Ganduxe Pregona on 31/3/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct OfficeUpdateData {
    
    let someString: String
}

enum OfficeUpdatesError: Error {
 
    case missingMajorMinorKey
    case missingDocument
}

typealias OfficeUpdatesClosure = (Result<OfficeUpdateData, OfficeUpdatesError>) -> Void

protocol OfficeUpdatesService {
    
    func fetchOfficeInfo(major: Int, minor: Int, completion: @escaping OfficeUpdatesClosure)
}

class OfficeUpdatesFakeService: OfficeUpdatesService {
    
    func fetchOfficeInfo(major: Int, minor: Int, completion: @escaping OfficeUpdatesClosure) {

        completion(.success(OfficeUpdateData(someString: "Fake bla bla")))
    }
}

class OfficeUpdatesFirebaseService: OfficeUpdatesService {
    
    private let db: Firestore
    
    init() {
        FirebaseApp.configure()
        self.db = Firestore.firestore()
    }
    
    func fetchOfficeInfo(major: Int, minor: Int, completion: @escaping OfficeUpdatesClosure) {

        let key = "\(major).\(minor)"
        
        let docRef = db.collection("office").document("offices")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                 // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                if let keyData = document.data()?[key] as? String {
                    completion(.success(OfficeUpdateData(someString: keyData)))

                } else {
                    completion(.failure(.missingMajorMinorKey))
                }
            } else {
            
                completion(.failure(.missingDocument))
            }
        }
        
    }
}
