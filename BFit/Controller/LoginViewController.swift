//
//  LoginViewController.swift
//  BFit
//
//  Created by Cody Price on 2/17/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
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
        errorMsg.textColor = UIColor.clear
    }

    @IBAction func login(_ sender: Any) {
        let usernameText = username.text!
        let passwordText = password.text!
        let url = "https://bfit-api.herokuapp.com/api/v1/login"
        
        if usernameText == ""  || passwordText == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter a username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let data = [
                "user": [
                    "username": usernameText,
                    "password": passwordText
                ]
            ]
            
            Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON {
                response in
                if response.result.isSuccess {
                    let userJSON : JSON = JSON(response.result.value!)
                    let id = userJSON["user_id"].stringValue
                    let def = UserDefaults.standard
                    def.set(true, forKey: "is_loggedIn")
                    def.set(id, forKey: "id")
                    def.synchronize()
                    self.performSegue(withIdentifier: "login", sender: sender)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Could not login user", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
     @IBAction func backToWelcome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
     }
}
