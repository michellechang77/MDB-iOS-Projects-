//
//  CreateEventVC.swift
//  MDB Social
//
//  Created by Michelle Chang on 6/11/21.
//

import Foundation
import NotificationBannerSwift
import FirebaseFirestore
import FirebaseStorage
import UIKit

class CreateEventVC: UIViewController, UINavigationControllerDelegate {
    private let titleLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = "Create an event"
            lbl.font = UIFont.boldSystemFont(ofSize: 25)
            lbl.textColor = UIColor(red: 133/255, green: 169/255, blue: 255/255, alpha: 1)
            lbl.textAlignment = .center
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        private let stack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .equalSpacing
            stack.spacing = 20

            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        private let contentEdgeInset = UIEdgeInsets(top: 35, left: 30, bottom: 40, right: 30)
        
        private let nameEventTextField: AuthTextField = {
            let tf = AuthTextField(title: "Name:")
            
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
        }()
        
        private let eventDescriptionField: AuthTextField = {
            let tf = AuthTextField(title: "Description:")
            
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
        }()
        
        private let createEventButton: UIButton = {
            let button = UIButton()
            button.setTitle("Create my event!", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 193/255, green: 211/255, blue: 254/255, alpha: 1)
            button.layer.cornerRadius = 20
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        private let datePicker: UIDatePicker =  {
            let dp = UIDatePicker()
            dp.translatesAutoresizingMaskIntoConstraints = false
            return dp
        }()
        
        private var pickedDate: Date?
            
        private let imagePicker: UIImagePickerController = {
            let ip = UIImagePickerController()
            return ip
        }()
        
        private let imagePickerBtn: UIButton = {
            let btn = UIButton()
            btn.setTitle("Select an image", for: .normal)
            btn.layer.cornerRadius = 10
            btn.setTitleColor(UIColor(red: 193/255, green: 211/255, blue: 254/255, alpha: 1), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
        
        private var pickedImage: UIImage?
        
        private var imageMeta: Any?
        
        private var pickedImageData: Data?
        
        private var pickedImageURL: URL?
        
        private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
        
        override func viewDidLoad() {
            view.backgroundColor = .background
            
            view.addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
            
            view.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
                stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdgeInset.right),
                stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
            ])
            stack.addArrangedSubview(nameEventTextField)
            stack.addArrangedSubview(eventDescriptionField)
            stack.addArrangedSubview(datePicker)
            stack.addArrangedSubview(imagePickerBtn)
            stack.addArrangedSubview(createEventButton)
            
            datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            datePicker.minuteInterval = 1
            datePicker.addTarget(self, action: #selector(didCreateDate(_:)), for: .valueChanged)
            
            imagePicker.delegate = self //idk about NavigationControllerDelegate
            imagePickerBtn.addTarget(self, action: #selector(didTapChooseImage(_:)), for: .touchUpInside)
            
            createEventButton.addTarget(self, action: #selector(didTapCreateEvent(_:)), for: .touchUpInside)
        }
        
        @objc func didCreateDate(_ datePicker: UIDatePicker) {
            let d: Date = datePicker.date
            pickedDate = d
            print("selected this date: \(d)")
        }
        
        @objc func didTapCreateEvent(_ sender: UIButton) {
            guard let name1 = nameEventTextField.text, name1 != "" else {
                showErrorBanner(withTitle: "Missing event name",
                                subtitle: "Please provide an event name")
                return
            }
            
            guard let desc = eventDescriptionField.text, desc != "" else {
                showErrorBanner(withTitle: "Missing event description",
                                subtitle: "Please provide an event description")
                return
            }
            if (desc.count > 140) {
                showErrorBanner(withTitle: "Event description too long",
                                subtitle: "Max 140 characters")
                return
            }
            if (pickedImage == nil) {
                showErrorBanner(withTitle: "Missing event image",
                                subtitle: "Please select an image")
                return
            }
            if (pickedDate == nil || pickedImageData == nil) {
                //will always be a date selected i think (default is current date+time)
                return
            }
            
            let currID: SOCUserID = SOCAuthManager.shared.currentUser!.uid ?? ""
            
            
            let ref = Storage.storage().reference().child(UUID().uuidString + ".jpeg")
            _ = ref.putData(pickedImageData!, metadata: nil) { (metadata, error) in
              ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("ERROR OCCURED WHILE DOWNLOADING URL - error: \(String(describing: error))")
                  return
                }
                let event: SOCEvent = SOCEvent(name: name1, description: desc, photoURL: downloadURL.relativeString, startTimeStamp: Timestamp(date: self.pickedDate!), creator: currID, rsvpUsers: [])
                //create document on firestore and set data
                FIRDatabaseRequest.shared.db.collection("events").document(event.id!)
                FIRDatabaseRequest.shared.setEvent(event, completion: {})
              }
            }
            dismiss(animated: true, completion: nil)
        }
        
        //stackoverflow credits :') https://stackoverflow.com/questions/41717115/how-to-make-uiimagepickercontroller-for-camera-and-photo-library-at-the-same-tim
        @objc func didTapChooseImage(_ sender: UIButton) {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            alert.view.addSubview(UIView())
            present(alert, animated: false, completion: nil)
        }
        
        private func openCamera() {
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.view.addSubview(UIView())
                present(alert, animated: false, completion: nil)
            }
        }
        
        private func openGallery() {
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                present(imagePicker, animated: true, completion: nil)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: false, completion: nil)
            }
        }
        
        private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
            guard bannerQueue.numberOfBanners == 0 else { return }
            let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                    titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                    subtitleFont: subtitle != nil ?
                                                        .systemFont(ofSize: 14, weight: .regular) : nil,
                                                    style: .warning)
            
            banner.show(bannerPosition: .top,
                        queue: bannerQueue,
                        edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                        cornerRadius: 10,
                        shadowColor: .primaryText,
                        shadowOpacity: 0.3,
                        shadowBlurRadius: 10)
        }
    }

    extension CreateEventVC: UIImagePickerControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                    //pickedImage = image
                    pickedImage = image.resized(withPercentage: 0.1)
                    pickedImageData = pickedImage?.jpegData(compressionQuality: 0.1)
                }
            if let url = info[.imageURL] as? URL {
                pickedImageURL = url
            }
            imageMeta = info[.mediaMetadata]
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    }

    extension UIImage {
        func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
                let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
                let format = imageRendererFormat
                format.opaque = isOpaque
                return UIGraphicsImageRenderer(size: canvas, format: format).image {
                    _ in draw(in: CGRect(origin: .zero, size: canvas))
                }
            }
    }
