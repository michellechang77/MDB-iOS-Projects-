//
//  SOCDBRequest.swift
//  MDB Social
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseFirestore

class SOCDBRequest {
    
    static let shared = SOCDBRequest()
    
    let db = Firestore.firestore()
    
    var listener: ListenerRegistration?
    
    func setUser(_ user: SOCUser, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    func setEvent(_ event: SOCEvent, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    /* TODO: Events getter */
<<<<<<< HEAD:MDB Social/MDB Social/MDB Social/Models/SOCDBRequest.swift
    func getEvents(vc: FeedVC)->[SOCEvent] {
            var events: [SOCEvent] = []
            if (SOCAuthManager.shared.isSignedIn()) {
                listener = db.collection("events").order(by: "startTimeStamp", descending: true)
                        .addSnapshotListener { querySnapshot, error in
                        events = []
                            if (SOCAuthManager.shared.isSignedIn()) {
                                guard let documents = querySnapshot?.documents else {
                                    print("Error fetching documents: \(error!)")
                                    print("error in getEvents")
                                    return
                                }
                                for document in documents {
                                    guard let event = try? document.data(as: SOCEvent.self) else {
                                        print("problem converting document into event")
                                        return
                                    }
                                    events.append(event)
                                }
                                vc.updateEvents(newEvents: events)
                            }
                    }
            
                return events
            }
            return events
        }
    }
=======
    // For example, see SOCAuthManager.linkUser(withuid:completion:)
}
>>>>>>> 23b07a6356d4e526b30091254109e7ba3e6e5e34:MDB Social/Project/MDB Social/Models/SOCDBRequest.swift
