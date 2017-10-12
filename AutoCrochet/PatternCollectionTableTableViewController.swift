//
//  PatternCollectionTableTableViewController.swift
//  AutoCrochet
//
//  Created by Carissa Ward on 6/4/17.
//  Copyright © 2017 DePaul. All rights reserved.
//

import UIKit

//This class is for the screen which displays all the created patterns. When the user selects one they are sent to the pattern.
class PatternCollectionTableTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patterns.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patternRow", for: indexPath)

        cell.textLabel?.text = patterns[indexPath.row].name
        cell.backgroundColor = patternColor

        return cell
    }

    //This function will make sure that the pattern display screen has the name of the pattern (for the screen title) and the pattern itself.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let patternInstructions = segue.destination as? RowsTableViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                patternInstructions.patternName = patterns[indexPath.row].name
                patternInstructions.pattern = patterns[indexPath.row].rows
            }
        }
    }

}
