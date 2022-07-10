//
//  BeaconEventsService.swift
//  Beacoffice
//
//  Created by Oriol Ganduxe Pregona on 31/3/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

enum EventsError: Error {

    case unexpectedData
    case missingMajorMinorKey
    case missingDocument
}

typealias EventsClousure = (Result<[Event], EventsError>) -> Void

protocol BeaconEventsService {
    
    func fetchEventsPublisher(beaconId: BeaconId) -> AnyPublisher<[Event], EventsError>
    func fetchOfficeInfo(beaconId: BeaconId, completion: @escaping EventsClousure)
}

class BeaconEventsFirebaseService: BeaconEventsService {
    
    private let db: Firestore
    
    init() {
        FirebaseApp.configure()
        self.db = Firestore.firestore()
    }
    
    // Combine interface
    func fetchEventsPublisher(beaconId: BeaconId) -> AnyPublisher<[Event], EventsError> {

        Deferred {
            Future { promise in
                self.fetchOfficeInfo(beaconId: beaconId) { result in
                    
                    switch result {
                    case .failure(let error):
                        promise(.failure(error))
                    case .success(let events):
                        promise(.success(events))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Non-combine interface
    func fetchOfficeInfo(beaconId: BeaconId, completion: @escaping EventsClousure) {
        
        let docRef = db.collection("office").document("ios")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                 // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                if let dict = document.data()?[beaconId.version] as? [String: String] {
                   
                    if let data = Event.createFrom(dict: dict) {
                        // TODO: Support multiple events on the same call
                        completion(.success([data]))
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
