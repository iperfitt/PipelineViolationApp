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
    
    //Tells the data source to return the number of rows in a given section of a table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pipelineNames.count
    }

    //Asks the data source for a cell to insert in a particular location of the table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    //Tells the delegate that the specified row is now selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "ETRoverViolationGuidelines", sender: self)
    }

   }
