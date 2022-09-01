//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Alperen Kavuk on 28.08.2022.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
    do
    {
        try Auth.auth().signOut()
        self.performSegue(withIdentifier: "toSignInVC", sender: nil)
    }
    catch
    {
        
    }

}
}
