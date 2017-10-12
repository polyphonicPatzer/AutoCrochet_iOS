//
//  ParametersViewController.swift
//  AutoCrochet
//
//  Created by Carissa Ward on 6/3/17.
//  Copyright © 2017 DePaul. All rights reserved.
//

import UIKit

//This class is for the screen which has form submission for pattern Creation.
class ParametersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = patternColor
    }

    //A button which closes the keyboard for any of the text fields when you click it
    @IBAction func closeKeyboard(_ sender: UIControl) {
        circumference.resignFirstResponder()
        width.resignFirstResponder()
        height.resignFirstResponder()
        patternName.resignFirstResponder()
    }
    
    //Allows the text keyboard for the pattern name to be closed when you click return
    @IBAction func closeNameKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This is connected to the Create button. This method starts off the creation of the pattern. 
    //It checks that the form has correct input otherwise it sends an alert.
    @IBAction func createPattern(_ sender: UIButton) {
        let circumference1 = circumference.text ?? "failed"
        let width1 = height.text ?? "failed"
        let height1 = width.text ?? "failed"
        let name1 = patternName.text ?? "failed"
        
        if (name1 == "" || name1 == "failed" || width1 == "" || width1 == "failed" || height1 == "" || height1 == "failed" || circumference1 == "" || circumference1 == "failed"){
            alert(displayMessage: "Make sure you have filled out each field.")
        }
        guard let circumference3 = Double(circumference1), circumference3 >= 9 else {
            alert(displayMessage: "Circumference must be a valid decimal greater than 9.0.")
            return
        }
        guard let height3 = Double(height1), height3>=0.1, height3<=22 else {
            alert(displayMessage: "Height must be a valid decimal between 0.1 and 22.")
            return
        }
        guard let width3 = Double(width1), height3>=0.1, height3<=22  else {
            alert(displayMessage: "Width must be a valid decimal between 0.1 and 11.")
            return
        }
        patternStitch = Stitch.init(hightInCm: height3, widthInCm: width3)
        
        let rows = generatePattern(circumference: circumference3)
        if rows.count == 0 {return}//if stitchNumArray was also empty within the generatePattern function
        
        patterns.append(Pattern.init(r: rows, n: "\(name1)"))
    }
    
    //variables used in the crochet pattern generating algorithm
    var R = 0.0
    var patternStitch = Stitch.init(hightInCm: 0.615384615, widthInCm: 0.73333333)
    @IBOutlet weak var patternName: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var width: UITextField!
    @IBOutlet weak var circumference: UITextField!
    
    
    //THis method calls all other methods needed for the pattern generation.
    //It calls equation many times to fill an array with the initial row lengths
    //Then it creates a new array which has the numbers from the getStitchCount method in a different order. so instead of a reversed sphere, it shapes a hat.
    //then calls getStitchCount which translates the initial measurements into stitch counts
    //The it generates a list of Rows based on the number of stitches needed in each row

    func generatePattern(circumference: Double) -> [Row]{
        
        R = circumference/(2.0*3.14159)
        var i = 0
        var rowCirc = equation(k: i)
        var arr = [Double]()
        
        while (rowCirc > 0.0){
            if (rowCirc > 6) {arr.append(rowCirc)}
            i = i + 1
            rowCirc = equation(k: i)
        }
        
        let stitchNumArray = getStitchCount(modifiedArray: modifyArray(initArray: arr))
        
        guard stitchNumArray.count>0 else {
            alert(displayMessage: "The given parameters cannot create a reasonable pattern.")
            return [Row]()
        }
        
        var output = [Row]()
        output.append(Row.init(previousStitchTotal: 0, currentStitchTotal: stitchNumArray[0], rowNumber: 1))
        for i in 1..<stitchNumArray.count{
            output.append(Row.init(previousStitchTotal: stitchNumArray[i-1], currentStitchTotal: stitchNumArray[i], rowNumber: i+1))
        }
        let lastI = stitchNumArray.count - 1
        output.append(Row.init(previousStitchTotal: stitchNumArray[lastI - 1], currentStitchTotal: stitchNumArray[lastI], rowNumber: lastI + 2))
        return output
    }
    
    //Generates the length of the circumference at different parts of the sphere, k being the hight along the outside of the sphere
    func equation(k: Int) -> Double{
        let output = 2 * 3.14159 * R * cos((Double(k)*patternStitch.height)/R)
        return output
    }
    
    //Then it creates a new array which has the numbers from the getStitchCount method in a different order. so instead of a reversed sphere, it shapes a hat.
    func modifyArray(initArray: [Double]) -> [Double]{
        var output = [Double]()
        for i in stride(from: initArray.count-1, to: 0, by: -1) {
            output.append(initArray[i])
        }
        for _ in 0..<Int(Double(initArray.count) * 0.65){
            output.append(initArray[0])
        }
        return output
    }
    
    //given the modified array, this method will determine the number of stitches needed in each row
    func getStitchCount(modifiedArray: [Double]) -> [Int]{
        var output = [Int]()
        for i in 0..<modifiedArray.count {
            output.append(Int(modifiedArray[i]/patternStitch.width))
        }
        return output
    }
    
    //The encapsulated alert
    func alert(displayMessage m : String){
        let message = m
        let alertController = UIAlertController(title: "Invalid Selection", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //The clear button clears all the fields. 
    @IBAction func clear(_ sender: UIButton) {
        circumference.text = ""
        height.text = ""
        width.text = ""
        patternName.text = ""
    }
}




