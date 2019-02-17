//
//  SignupViewController.swift
//  BFit
//
//  Created by Cody Price on 2/17/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SignupViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground() 

        // Do any additional setup after loading the view.
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
    

    @IBAction func signUpUser(_ sender: Any) {
        let usernameValue = username.text!
        let emailValue = email.text!
        let passwordValue = password.text!
        let urlString = "https://bfit-api.herokuapp.com/api/v1/users"
        
        let data = [
            "username" : usernameValue,
            "email" : emailValue,
            "avatar" : "",
            "password" : passwordValue
        ]
        
        print(data)
        
        Alamofire.request(urlString, method: .post, parameters: data, encoding: JSONEncoding.default, headers: ["Content-Type" : "application/x-www-form-urlencoded"]).responseJSON {
            response in
            if response.result.isSuccess {
                print("success: \(response.result)")
            } else {
                print("failure: \(String(describing: response.response?.statusCode)) \(String(describing: response.result.error))")
            }
        }
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
