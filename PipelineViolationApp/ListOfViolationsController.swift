//
//  ListOfViolationsController.swift
//  PipelineViolationApp
//
//  Created by Perfitt, Ian on 9/17/17.
//  Copyright © 2017 Perfitt, Ian. All rights reserved.
//

import UIKit

var pipelineNames2 = ["ET Rover"]
var myIndex2 = 0

class ListOfViolationsController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pipelineNames2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex2 = indexPath.row
        performSegue(withIdentifier: "ETRoverReportDocumentSegue", sender: self)
    }
    
}
