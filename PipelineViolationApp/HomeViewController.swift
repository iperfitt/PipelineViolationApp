//
//  ViewController.swift
//  PipelineViolationApp
//
//  Created by Perfitt, Ian on 9/17/17.
//  Copyright © 2017 Perfitt, Ian. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func ReportAViolation(_ sender: Any) {
        self.performSegue(withIdentifier: "ReportAViolationSegue", sender: self)
    }
    @IBAction func ReportViolation(_ sender: Any) {
        self.performSegue(withIdentifier: "TipsSegue", sender: self)
    }
    
    @IBAction func WhatCountsAsViolationListOfPipelines(_ sender: Any) {
        self.performSegue(withIdentifier: "ListOfPipelinesWhatCountsAsAViolationSegue", sender: self)
    }
    
    @IBAction func MapOfReports(_ sender: Any) {
        self.performSegue(withIdentifier: "MapSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

