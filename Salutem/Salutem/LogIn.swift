import UIKit
import FirebaseAuth
import SVProgressHUD
import FirebaseDatabase

class SignIn: UITableViewController {
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    var isAPatient: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAPatient = true
    }
    
    @IBAction func signIn(_ sender: Any) {
        SVProgressHUD.show()
        if (emailAddress?.text == "" || password.text == "") {
            showAlert(title: "Oops!", message: "One of the text fields were left incomplete! Please enter in an email or password to access your account.")
            SVProgressHUD.dismiss()
        }else {
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: emailAddress.text!, password: password.text!) { [weak self] user, error in
                if (error != nil) {
                    self?.showAlert(title: "Oops!", message: "Your information was incorrect. Please try again.")
                    SVProgressHUD.dismiss()
                }else {
                    self!.readFromDB{ (success) in
                        if(success){
                            SVProgressHUD.show()
                            self?.performSegueFunction(storyboardName: "Main")
                            SVProgressHUD.dismiss()
                        }
                    }
                    
                }
            }
            
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func performSegueFunction(storyboardName: String) {
        if(self.isAPatient){
            let viewController:UIViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "patient") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }else {
            let viewController:UIViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "doctor") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }
        
    }
    
    func readFromDB(success:@escaping (Bool) -> Void){
        let currentUID = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference()
        
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let values = Array(data.values)
                let uid = Array(data.keys)
                //                    let uid = name2.sorted { $0 < $1 }
                
                // print(data)
                let valueDict  = values as! [[String: Any]]
                var intValue = 0
                for object in valueDict{
                    if(uid[intValue] == currentUID){
                        let doctorStatus = object["isDoctor"] as! Bool
                        self.isAPatient = !doctorStatus
                    }
                    
                    intValue += 1
                }
                
                success(true)
            }
        }) { (error) in  print(error.localizedDescription) }
        
    }
    
}
