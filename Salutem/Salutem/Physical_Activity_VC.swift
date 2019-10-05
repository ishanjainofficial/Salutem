//
//  Physical_Activity_VC.swift
//  Salutem
//
//  Created by sid on 9/21/19.
//  Copyright © 2019 sid. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CoreLocation

class Physical_Activity_VC: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        submitButton.layer.cornerRadius = 30
        label1.text = "0 hrs"
        label2.text = "0 hrs"
        label3.text = "0 hrs"
        label4.text = "0 hrs"

        locManager.requestWhenInUseAuthorization()
        
        guard let currentLocation = locManager.location else {
            return
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            self.lat = currentLocation.coordinate.latitude
            self.long = currentLocation.coordinate.longitude
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateValue(_ sender: UISlider) {
        var value = sender.value
        let denominator: Float = 2;
        value = round(value*denominator)/denominator
        switch sender.tag {
        case 0:
            label1.text = "\(value) hrs"
        case 1:
            label2.text = "\(value) hrs"
        case 2:
            label3.text = "\(value) hrs"
        case 3:
            label4.text = "\(value) hrs"
        default:
            print("nothing")
        }
    }
    
    
    
    @IBAction func submitToFirebase(_ sender: Any) {
        SVProgressHUD.show()
        
        saveMedData(hike: label1.text!, run: label2.text!, swim: label3.text!, bike: label4.text!)
        
        performSegue(withIdentifier: "camera", sender: nil)
        
        SVProgressHUD.dismiss()
    }
    
    func saveMedData(hike: String, run: String, swim: String, bike: String) {
        let userID = Auth.auth().currentUser?.uid
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        print(formattedDate)
        
        self.ref.child("med-data").child(userID!).child(formattedDate).setValue(["hike": hike, "run": run, "swim": swim, "bike": bike])
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
