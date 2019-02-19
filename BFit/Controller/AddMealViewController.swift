//
//  AddMealViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON

class AddMealViewController: UIViewController {
    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var foodOne: UITextField!
    @IBOutlet weak var calOne: UITextField!
    @IBOutlet weak var foodTwo: UITextField!
    @IBOutlet weak var calTwo: UITextField!
    @IBOutlet weak var foodThree: UITextField!
    @IBOutlet weak var calThree: UITextField!
    @IBOutlet weak var foodFour: UITextField!
    @IBOutlet weak var calFour: UITextField!
    @IBOutlet weak var foodFive: UITextField!
    @IBOutlet weak var calFive: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
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
    
    @IBAction func submitMeal(_ sender: Any) {
        let urlString = "https://bfit-api.herokuapp.com/api/v1/post"
        let mealNameText = mealName.text
        let foodOneText = foodOne.text
        let calOneText = calOne.text
        let foodTwoText = foodTwo.text
        let calTwoText = calTwo.text
        let foodThreeText = foodThree.text
        let calThreeText = calThree.text
        let foodFourText = foodFour.text
        let calFourText = calFour.text
        let foodFiveText = foodFive.text
        let calFiveText = calFive.text
        let id = UserDefaults.standard.string(forKey: "id")!
        let data = [
            "title" : mealNameText!,
            "description" : "",
            "image_url" : "",
            "post_type" : "meal",
            "user_id" : id,
            "meal" : [
                "name" : mealNameText!,
                "foods" : [
                    ["name" : foodOneText,
                     "calories" : calOneText],
                    ["name" : foodTwoText,
                     "calories" : calTwoText],
                    ["name" : foodThreeText,
                     "calories" : calThreeText],
                    ["name" : foodFourText,
                     "calories" : calFourText],
                    ["name" : foodFiveText,
                     "calories" : calFiveText]
                ]
            ]
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
