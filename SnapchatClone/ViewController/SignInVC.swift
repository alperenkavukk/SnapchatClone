//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Alperen Kavuk on 28.08.2022.
//

import UIKit
import Firebase
class SignInVC: UIViewController {

    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SignInClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" && mailText.text != ""{
            Auth.auth().signIn(withEmail: mailText.text!, password: passwordText.text!){ (result, eror ) in
            if eror != nil {
                self.makeAlert(Title: "Eror", message: "girilmedi")
            }
            else
        {
                self.performSegue(withIdentifier: "toFeedVc", sender: nil)
        }
                 
            }
        }
        else
        {
            self.makeAlert(Title: "eror", message: "kullanıcı bulunamadı")
        }
        
    }
    
    @IBAction func SignUpClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" && mailText.text != ""{
            
        Auth.auth().createUser(withEmail: mailText.text!, password: passwordText.text!) {( auth, eror ) in
            if eror != nil {
                self.makeAlert(Title: "Eror", message: eror?.localizedDescription ?? "Eror")
            }
            else
            {
                let fireStore = Firestore.firestore()
                let userDictionary = [" email " : self.mailText.text!,"username" : self.userNameText.text!] as! [String : Any]
                fireStore.collection("userInfo").addDocument(data: userDictionary){
                    (eror) in
                    if eror != nil {
                        //
                    }
                }
               
               
                self.performSegue(withIdentifier: "toFeedVc", sender: nil)
            }
            }
      
        
        }
        else
        {
            self.makeAlert(Title: "Eror", message: "Herhangi Biri boş Bırakılamaz")
        }
    }
    func makeAlert(Title: String, message: String){
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil )
        alert.addAction(okbutton)
        self.present(alert,animated: true,completion:  nil)
        
    }
}

