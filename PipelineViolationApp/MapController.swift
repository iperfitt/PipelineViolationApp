//
//  MapController.swift
//  PipelineViolationApp
//
//  Created by Ian Perfitt on 10/19/17.
//  Copyright © 2017 Perfitt, Ian. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class MapController: UIViewController {
    
    @IBOutlet var Map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gets a FIRDatabaseReference for the location at the specified relative path.
        let ref = Database.database().reference().child("PINS")
        //Read data from the Firebase Database.
        ref.observe(DataEventType.value, with:{ (snapshot) in
            //Check number of children
            if snapshot.childrenCount > 0 {
                //Loop through pins
                for pin in snapshot.children.allObjects as![DataSnapshot] {
                    //Grab pin object
                    let pinObject = pin.value as? [String: AnyObject]
                    //Set latitude and longitude associated with a location
                    let CLLCoordType = CLLocationCoordinate2D(latitude: pinObject?["latitude"] as! CLLocationDegrees, longitude: pinObject?["longitude"] as! CLLocationDegrees)
                    //Annotation object tied to the specified point on the map.
                    let anno = MKPointAnnotation()
                    anno.coordinate = CLLCoordType
                    anno.title = pinObject!["message"] as? String
                    //Add annotation to map
                    self.Map.addAnnotation(anno)
                }
            }
        })
    }
}
