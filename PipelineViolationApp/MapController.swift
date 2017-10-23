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
        let ref = Database.database().reference().child("PINS")
        ref.observe(DataEventType.value, with:{ (snapshot) in
            if snapshot.childrenCount > 0 {
                for pin in snapshot.children.allObjects as![DataSnapshot] {
                    let pinObject = pin.value as? [String: AnyObject]
                    let CLLCoordType = CLLocationCoordinate2D(latitude: pinObject?["latitude"] as! CLLocationDegrees, longitude: pinObject?["longitude"] as! CLLocationDegrees)
                    let anno = MKPointAnnotation()
                    anno.coordinate = CLLCoordType
                    anno.title = pinObject!["message"] as! String
                    self.Map.addAnnotation(anno)
                }
            }
        })
    }
}
