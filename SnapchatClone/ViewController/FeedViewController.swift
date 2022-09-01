//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Alperen Kavuk on 28.08.2022.
//

import UIKit
import Firebase
class FeedViewController: UIViewController {

    let FireStoreDatabase = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        kullaniciBilgileriAl()
        
}
    func kullaniciBilgileriAl(){
    
        FireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, eror )in
            if eror != nil {
                self.makeAlert(Title: "Eror", message: "not registered")
            }
            else
            {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents
                    {
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
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
