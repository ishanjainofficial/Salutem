//
//  MapView.swift
//  Food Zone
//
//  Created by Ishan Jain on 4/6/19.
//  Copyright © 2019 Food Zone. All rights reserved.
//

import CoreLocation
import MapKit
import Firebase

class MapView: UIViewController {
    
    var ref: DatabaseReference!
    @IBOutlet weak var map: MKMapView!
    var databaseHandle:DatabaseHandle = 0
    
    var id: String = ""
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        addAnnotations()
    }
    
    func addAnnotations() {
        
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("locations").observe(.value, with: { snapshot in
            // This is the snapshot of the data at the moment in the Firebase database
            // To get value from the snapshot, we user snapshot.value
            let value = snapshot.value as! [String: AnyObject]
            
            
            let valKeys = Array(value.keys)
            
            for key in valKeys  {
                
                guard
                    
                    let value = value[key] as? [String:AnyObject]
                    
                    else {
                    continue
                }
                
                let email = value["email"] as? String
                let id = value["id"] as? String
                let lat = value["latitude"] as? Double
                let lon = value["longitude"] as? Double
                
                self.id = id!
                self.email = email!
                
                let annotation = MKPointAnnotation()
                annotation.title = email
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat!) as! CLLocationDegrees, longitude: Double(lon!) as! CLLocationDegrees)
                self.map.addAnnotation(annotation)
            }
            
            // ...
        }) { (error) in
            self.showAlertView(title: "Oops!", message: error.localizedDescription)
        }
        
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let alert = UIAlertController(title: email, message: "This is \(id)'s account. Would you like to diagnose his/her information?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "View Info", style: .destructive, handler: { (action) in
            //self.performSegue(withIdentifier: "", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
