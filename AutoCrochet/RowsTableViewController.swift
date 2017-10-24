//
//  RowsTableViewController.swift
//  AutoCrochet
//
//  Created by Carissa Ward on 6/3/17.
//  Copyright © 2017 DePaul. All rights reserved.
//

import UIKit

//This class is for the screen which displays the pattern. It shows topical information about each row.
class RowsTableViewController: UITableViewController {

    @IBOutlet weak var patternTableTitle: UINavigationItem!
    var pattern : [Row]?
    var patternName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patternTableTitle.title = patternName ?? "Error"
        self.view.backgroundColor = lightBackground
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowList = pattern{
            return rowList.count
        }else{
            return 1
        }
    }

    //This method populates the list. If a row is as complete, it will appear as green instead of gray.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "specificRow", for: indexPath)

        if let rowList = pattern{
            cell.textLabel?.text = "\(rowList[indexPath.row].label)         \(rowList[indexPath.row].stNum) sc, \(rowList[indexPath.row].incNum) \(rowList[indexPath.row].incOrDec), \(rowList[indexPath.row].total) total."
            
            //Ths checks if all segments in the row are marked as complete or not
            var completed = true
            for segment in rowList[indexPath.row].segments{
                if segment.1 == false {
                    completed = false
                    break
                }
            }
            cell.backgroundColor = (completed ? complete : incomplete)
        } else {
            cell.textLabel?.text = "Error"
        }
        
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    //This sends the intructions about a particular row to the next screen, which displays them in detail.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let rowInstructions = segue.destination as? RowTableViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow, let rowList = pattern {
                rowInstructions.testRow = rowList[indexPath.row]
            }
        }
        
    }


}











