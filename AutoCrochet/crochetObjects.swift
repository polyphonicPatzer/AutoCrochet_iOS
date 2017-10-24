//
//  crochetObjects.swift
//  AutoCrochet
//
//  Created by Carissa Ward on 6/3/17.
//  Copyright © 2017 DePaul. All rights reserved.
//

import Foundation
import UIKit


let complete = UIColor(red:0.60, green:0.48, blue:1.00, alpha:1.0)
let incomplete = UIColor(red:0.49, green:0.48, blue:0.50, alpha:1.0)
let lightBackground = UIColor(red:0.90, green:0.88, blue:1.00, alpha:1.0)

var patterns = [Pattern]()

class Pattern {
    var rows = [Row]()
    let name: String
    
    init(r: [Row], n: String){
        self.rows = r
        self.name = n
    }
}

class Row {
    var incNum: Int
    var stNum: Int
    var total: Int
    var incOrDec: String
    var label: String
    var segments: [(String, Bool)] = []
    
    init(previousStitchTotal: Int, currentStitchTotal: Int, rowNumber: Int){
        label = "Row \(rowNumber)"
        if (previousStitchTotal == 0){
            stNum = currentStitchTotal
            incNum = 0
            total = currentStitchTotal
            incOrDec = "inc"
        }
        else if (currentStitchTotal == 0){
            stNum = 0
            incNum = previousStitchTotal/2
            total = 0
            incOrDec = "dec"
        }
        else{
            total = currentStitchTotal
            let difference = currentStitchTotal - previousStitchTotal
            if (difference < 0){
                incNum = abs(difference)
                incOrDec = "dec"
                stNum = currentStitchTotal + difference
            }
            else{
                incNum = difference
                stNum = previousStitchTotal - difference
                incOrDec = "inc"
            }
        }
        setSegments()
    }
    
    func setSegments(){
        if incNum == 0{
            segments.append(("\(stNum) sc", false))
        }
        else if (stNum == 0){
            segments.append(("\(incNum) \(incOrDec)", false))
        }
        else{
            let segmentAmount = stNum/incNum
            let leftover = stNum%incNum
            for _ in 1...incNum{
                segments.append(("\(segmentAmount) sc, 1 \(incOrDec)", false))
            }
            if (leftover > 0){
                segments.append(("\(leftover) sc", false))
            }
        }
    }
    
    func check(segmentNum: Int){
        segments[segmentNum].1 = true
    }
}



class Stitch{
    var width: Double
    var height: Double
    init(hightInCm h: Double, widthInCm w: Double){
        self.width = w
        self.height = h
    }
}

func equation(){
    
}
