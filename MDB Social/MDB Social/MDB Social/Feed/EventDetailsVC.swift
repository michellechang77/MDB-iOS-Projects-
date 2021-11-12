//
//  EventDetailsVC.swift
//  MDB Social
//
//  Created by Michelle Chang on 6/11/21.
//
import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

class EventDetailsVC: UIViewController {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var currEvent: SOCEvent? {
        didSet {
            let gsReference: StorageReference = Storage.storage().reference(forURL: currEvent!.photoURL)
            gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("oh no: \(error)")
                  } else {
                    self.imageView.image = UIImage(data: data!)
                  }
            }
            
            nameEvent.text = currEvent!.name
            rsvpd.text = "RSVP'ed: \(currEvent?.rsvpUsers.count ?? 0)"
            let docRef = FIRDatabaseRequest.shared.db.collection("users").document(currEvent!.creator)
            docRef.getDocument(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Could not retrieve document: \(err)")
                } else {
                    guard let user = try? querySnapshot?.data(as: SOCUser.self) else {
                        print("Could not retrieve user")
                        return
                    }
                    self.nameCreator.text = "Creator: " + user.fullname
                    
                }
            })
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm E, d MMM y"
            date.text = "Date: " + formatter.string(from: currEvent!.startDate)
            desc.text = currEvent?.description
            
            for id in currEvent!.rsvpUsers {
                if (SOCAuthManager.shared.currentUser?.uid == id) {
                    isRsvpd = true
                    break
                }
            }
            if (currEvent?.creator == SOCAuthManager.shared.currentUser?.uid) {
                isCreator = true
                print("current user is the creator")
            }
        }
    }
    
    private var isCreator: Bool = false
    
    private var isRsvpd: Bool = false
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var nameEvent: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameCreator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var date: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var rsvpd: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var desc: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0 //unlimited # lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var rsvpBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .lightGray
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.layer.cornerRadius = 20
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var deleteEvent: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 15
        btn.backgroundColor = .lightGray
        btn.setTitle("Delete Event", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 70, left: 20, bottom: 30, right: 20)
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 193/255, green: 211/255, blue: 254/255, alpha: 1)
        
        view.addSubview(deleteEvent)
        deleteEvent.addTarget(self, action: #selector(didTapDeleteEvent(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            deleteEvent.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            deleteEvent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteEvent.widthAnchor.constraint(equalToConstant: 110)
        ])
        
        if (isCreator) {
            deleteEvent.isHidden = false
        }
        
        if (isRsvpd) {
            rsvpBtn.setTitle("Cancel RSVP", for: .normal)
        } else {
            rsvpBtn.setTitle("RSVP", for: .normal)
        }
        
        view.addSubview(stack)
        stack.addArrangedSubview(nameEvent)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(nameCreator)
        stack.addArrangedSubview(date)
        stack.addArrangedSubview(desc)
        stack.addArrangedSubview(rsvpd)
        stack.addArrangedSubview(rsvpBtn)
        rsvpBtn.addTarget(self, action: #selector(didTapRsvp(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: contentEdgeInset.top),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        
    }
    
    @objc func didTapRsvp(_ sender: UIButton) {
        let eventRef = FIRDatabaseRequest.shared.db.collection("events").document(currEvent!.id!)
        print("path:" + eventRef.path)
        if (isRsvpd) {
            isRsvpd = false
            for i in 0..<currEvent!.rsvpUsers.count {
                if currEvent?.rsvpUsers[i] == SOCAuthManager.shared.currentUser?.uid {
                    eventRef.updateData([
                        "rsvpUsers": FieldValue.arrayRemove([currEvent!.rsvpUsers[i]])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    currEvent?.rsvpUsers.remove(at: i)
                    break
                }
            }
            
            rsvpBtn.setTitle("RSVP!", for: .normal)
        } else {
            isRsvpd = true
            eventRef.updateData([
                "rsvpUsers": FieldValue.arrayUnion([(SOCAuthManager.shared.currentUser?.uid)!])
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }

            currEvent?.rsvpUsers.append((SOCAuthManager.shared.currentUser?.uid)!)
            rsvpBtn.setTitle("Cancel RSVP", for: .normal)
        }
        
    }
    
    @objc func didTapDeleteEvent(_ sender: UIButton) {
        let eventRef = FIRDatabaseRequest.shared.db.collection("events").document(currEvent!.id!)
        eventRef.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}
