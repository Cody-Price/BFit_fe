//
//  AddWorkoutViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit

class AddWorkoutViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let mockMuscleData = muscleGroupMockData().workoutsDictionary
    var listOfMuscles : [String] = [String]()
    var listOfExercises : [String] = [String]()

    
    @IBOutlet weak var musclePicker: UIPickerView!
    @IBOutlet weak var exercisePicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musclePicker.delegate = self
        musclePicker.dataSource = self
        exercisePicker.delegate = self
        exercisePicker.dataSource = self
        listOfMuscles = Array(mockMuscleData.keys)
        listOfExercises = mockMuscleData[Array(mockMuscleData.keys)[0]]!

        // Do any additional setup after loading the view.
        setGradientBackground()
        print(mockMuscleData)
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 46.0/255.0, green: 64.0/255.0, blue: 87.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 254.0/255.0, green: 93.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == musclePicker {
            return listOfMuscles.count
        } else {
            return listOfExercises.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == musclePicker {
            return listOfMuscles[row]
        } else {
            return listOfExercises[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == musclePicker {
            let muscleRow = row
            setExercisesList(muscle: listOfMuscles[muscleRow])
            exercisePicker.selectRow(0, inComponent: 0, animated: true)
            self.exercisePicker.reloadAllComponents()
        }
    }
    
    func setExercisesList(muscle : String) {
        self.listOfExercises = mockMuscleData[muscle]!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
