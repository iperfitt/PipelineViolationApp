//
//  ListOfPipelineWhatCountsAsReportController.swift
//  PipelineViolationApp
//
//  Created by Perfitt, Ian on 9/17/17.
//  Copyright © 2017 Perfitt, Ian. All rights reserved.
//

import UIKit

var pipelineNames = ["ET Rover"]
var myIndex = 0

class ListOfPipelineWhatCountsAsReportController: UITableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pipelineNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pipelineNames[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "ETRoverViolationGuidelines", sender: self)
    }

   }
