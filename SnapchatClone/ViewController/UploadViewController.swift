//
//  UploadViewController.swift
//  SnapchatClone
//
//  Created by Alperen Kavuk on 28.08.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func choosePicture(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        //Storage
           
           let storage = Storage.storage()
           let storageReference = storage.reference()
           
           let mediaFolder = storageReference.child("media")
           
           
           if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
               
               let uuid = UUID().uuidString
               
               let imageReference = mediaFolder.child("\(uuid).jpg")
               
               imageReference.putData(data, metadata: nil) { (metadata, error) in
                   if error != nil {
                       self.makeAlert(Title: "Error", message: error?.localizedDescription ?? "Error")
                   } else {
                       
                       imageReference.downloadURL { (url, error) in
                           if error == nil {
                               
                               let imageUrl = url?.absoluteString
                               
                               //Firestore
                               
                               let fireStore = Firestore.firestore()
                               
                               fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                   if error != nil {
                                       self.makeAlert(Title: "Error", message: error?.localizedDescription ?? "Error")
                                   } else {
                                       if snapshot?.isEmpty == false && snapshot != nil {
                                           for document in snapshot!.documents {
                                               
                                               let documentId = document.documentID
                                               
                                               if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                   imageUrlArray.append(imageUrl!)
                                                   
                                                   let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                   
                                                   fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { (error) in
                                                       if error == nil {
                                                           self.tabBarController?.selectedIndex = 0
                                                           self.imageView.image = UIImage(named: "selectimage.png")
                                                       }
                                                   }
                                                   
                                                   
                                               }
                                               
                                               
                                           }
                                       } else {
                                           let snapDictionary = ["imageUrlArray" : [imageUrl!], "snapOwner" : UserSingleton.sharedUserInfo.username,"date":FieldValue.serverTimestamp()] as [String : Any]
                                           
                                           fireStore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                               if error != nil {
                                                   self.makeAlert(Title: "Error", message: error?.localizedDescription ?? "Error")
                                               } else {
                                                   self.tabBarController?.selectedIndex = 0
                                                   self.imageView.image = UIImage(named: "selectimage.png")
                                               }
                                           }
                                       }
                                   }
                               }
                               
                               
                               
                               
                               
                               
                           }
                       }
                       
                       
                   }
               }
               
               
               
           }
           
       }
       
    func makeAlert(Title: String, message: String){
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil )
        alert.addAction(okbutton)
        self.present(alert,animated: true,completion:  nil)
        
    }
}
