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

class MapController: UIViewController {
    
    @IBOutlet var Map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let location = CLLocationCoordinate2DMake(42.2808, -83.7430)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "mamamiapizzapie"
        annotation.subtitle = "Luna Rosa"
        Map.addAnnotation(annotation)
        
    }
    
    
    
    
    
}
