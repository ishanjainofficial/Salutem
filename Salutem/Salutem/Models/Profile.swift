//
//  Profile.swift
//  Salutem
//
//  Created by Ishan Jain on 9/22/19.
//  Copyright © 2019 Salutem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MyProfile: UITableViewController {
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var statusType: UILabel!
    @IBOutlet weak var id: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.title = "My Profile"
        
        SVProgressHUD.show()
        
        retrieveUserInformation()
        
        SVProgressHUD.dismiss()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func retrieveUserInformation() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            let name = value?["fullName"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let phone = value?["phone"] as? String ?? ""
            
            let acctType = value?["isDoctor"] as? String ?? ""
            
            let id = value?["id"] as? String ?? ""
            
            self.name.text = name
            self.email.text = email
            self.phone.text = phone
            
            self.id.text = id
            
            self.statusType.text = acctType
            
            // ...
        }) { (error) in
            self.showAlertView(title: "Oops!", message: error.localizedDescription)
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        logoutNavigation()
    }
    
    func logoutNavigation() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "logout")
        self.present(controller, animated: true, completion: nil)
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
