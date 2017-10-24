//
//  RowTableViewController.swift
//  AutoCrochet
//
//  Created by Carissa Ward on 6/3/17.
//  Copyright © 2017 DePaul. All rights reserved.
//

import UIKit
import AudioKit

//This class is for the row screen. It displays more detailed information about the specific row selected. If the user makes a loud enough sound (like saying the word "check" or knocking on the table, the next segment of instructions is marked as complete.
class RowTableViewController: UITableViewController {

    var testRow : Row?

    @IBOutlet weak var rowTableTitle: UINavigationItem!
    var microphone: AKMicrophone!
    var waveformTracker: AKFrequencyTracker!
    var node: AKBooster!
    var sayingWord: Bool = false
    
    //This method creates the objects needed for the microphone listening.
    override func viewDidLoad() {
        super.viewDidLoad()
        AKSettings.audioInputEnabled = true
        microphone = AKMicrophone()
        waveformTracker = AKFrequencyTracker(microphone)
        node = AKBooster(waveformTracker, gain: 0)
        
        if let row = testRow{
            rowTableTitle.title = row.label
        }else{
            rowTableTitle.title = "Error"
            
        }
        
        self.view.backgroundColor = lightBackground
    }
    
    //This method starts a timer which listens for microphone input, and starts the use of the audioKit
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AudioKit.output = node
        AudioKit.start()
        
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(ViewController.update),
                             userInfo: nil,
                             repeats: true)
    }
    
    //This function stops the audioKit and by extension the listening.
    override func viewWillDisappear(_ animated: Bool) {
        AudioKit.stop()
    }
    
    //This method determines what the amplitude and if it's nature is that of a distinct noise intended to mark the completino of a row.
    func update() {
        let amplitude = waveformTracker.amplitude
        if amplitude < 0.06{
            sayingWord = false
        }
        else{
            if !sayingWord{
                if let row = testRow{
                    for i in 0..<row.segments.count{
                        if !row.segments[i].1 {
                            row.segments[i].1 = true
                            self.tableView.reloadData()
                            break
                        }
                    }
                    sayingWord = true
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let row = testRow{
            return row.segments.count
        }else{
            return 1
        }
    }

    //If a segment of instructions has been completed already, it will appear as green instead of gray.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath)
        if let row = testRow{
            cell.textLabel?.text = row.segments[indexPath.row].0
            cell.backgroundColor = (row.segments[indexPath.row].1 ? complete : incomplete)
        }else{
            cell.textLabel?.text = "Error"
        }
        return cell
    }
    
    //If the user clicks on a section of segments manually, it's state of completion will reverse. So if they want to mark it as completed manually they can, and if they want to undo an unintentional noise they can.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let row2 = testRow{
            row2.segments[indexPath.row].1 = !row2.segments[indexPath.row].1
        }
        self.tableView.reloadData()
    }


}
