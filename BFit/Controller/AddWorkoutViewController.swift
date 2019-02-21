//
//  AddWorkoutViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON

class AddWorkoutViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let mockMuscleData = muscleGroupMockData().workoutsDictionary
    var listOfMuscles : [String] = [String]()
    var listOfExercises : [String] = [String]()
    var muscle : String = ""
    var exercise : String = ""

    
    @IBOutlet weak var musclePicker: UIPickerView!
    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBOutlet weak var weightORTime: UITextField!
    @IBOutlet weak var repsORDistance: UITextField!
    @IBOutlet weak var shareBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musclePicker.delegate = self
        musclePicker.dataSource = self
        exercisePicker.delegate = self
        exercisePicker.dataSource = self
        listOfMuscles = Array(mockMuscleData.keys)
        listOfExercises = mockMuscleData[Array(mockMuscleData.keys)[0]]!
        setGradientBackground()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == musclePicker {
            let titleData = listOfMuscles[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
            if row == 0 {
                muscle = listOfMuscles[row]
            }
            return myTitle
        } else {
            let titleData = listOfExercises[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
            if row == 0 {
                exercise = listOfExercises[row]
            }
            return myTitle
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == musclePicker {
            let muscleRow = row
            setExercisesList(muscle: listOfMuscles[muscleRow])
            self.muscle = listOfMuscles[muscleRow]
            exercisePicker.selectRow(0, inComponent: 0, animated: true)
            self.exercisePicker.reloadAllComponents()
        } else {
            let exRow = row
            self.exercise = listOfExercises[exRow]
        }
    }
    
    func setExercisesList(muscle : String) {
        self.listOfExercises = mockMuscleData[muscle]!
    }
    
    @IBAction func submitWorkout(_ sender: Any) {
        let urlString = "https://bfit-api.herokuapp.com/api/v1/posts"
        let WOT = weightORTime.text
        let ROD = repsORDistance.text
        let id = UserDefaults.standard.string(forKey: "id")!
        
        if WOT == "" || ROD == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter a numeric value in both text fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let data = [
                "title" : exercise,
                "description" : "",
                "image_url" : "",
                "post_type" : "exercise",
                "user_id" : Int(id)!,
                "muscle_group" : muscle,
                "name" : exercise,
                "weightORTime" : WOT!,
                "repsORDistance" : ROD!
            ] as [String : Any]
            
            Alamofire.request(urlString, method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON {
                response in
                if response.result.isSuccess {
                    self.tabBarController!.selectedIndex = 0
                } else {
                    let alert = UIAlertController(title: "Error", message: "Problem communicating with server during post request.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

