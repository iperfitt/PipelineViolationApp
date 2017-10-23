//
//  PinController.swift
//  PipelineViolationApp
//
//  Created by Ian Perfitt on 10/22/17.
//  Copyright © 2017 Perfitt, Ian. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class PinController: UIViewController, CLLocationManagerDelegate {
    
    var latitude = 0.0
    
    var longitude = 0.0
    
    @IBOutlet var SavePinButton: UIButton!
    
    @IBOutlet var PinMessage: UITextField!
    
    @IBOutlet var SavedPin: UILabel!
    
    @IBOutlet var EnterMessageLabel: UILabel!
    
    
    //Obtaining location
    let manager = CLLocationManager()
    
    //Called every single time the user changes its position
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    @IBAction func SavePin(_ sender: Any) {
        let message = PinMessage.text
        let post : [String : AnyObject] = ["message": message as AnyObject,
                                           "latitude": latitude as AnyObject,
                                           "longitude": longitude as AnyObject]
        let databaseRef = Database.database().reference()
        databaseRef.child("PINS").childByAutoId().setValue(post)
        PinMessage.isHidden = true
        SavePinButton.isHidden = true
        EnterMessageLabel.isHidden = true
        SavedPin.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SavedPin.isHidden = true
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
}
