//
//  ViewController.swift
//  AutoCrochet
//
//  Created by Carissa Ward on 6/3/17.
//  Copyright © 2017 DePaul. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    

    @IBOutlet weak var amplitudeLabel: UILabel!
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var node: AKBooster!
    var sayingWord: Bool = false
    @IBOutlet weak var distinct: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        node = AKBooster(tracker, gain: 0)
    }
    
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
    
    func update() {
        let amp = tracker.amplitude
        
        amplitudeLabel.text = String(format: "%0.2f", amp)
        
        if amp < 0.03{
            sayingWord = false
        }
        else{
            if !sayingWord{
                distinct.text = (distinct.text ?? "") + "check\n"
                sayingWord = true
            }
        }
    }
}















