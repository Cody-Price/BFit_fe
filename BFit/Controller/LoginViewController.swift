//
//  LoginViewController.swift
//  BFit
//
//  Created by Cody Price on 2/17/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var errorMsg: UILabel!
    
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
    
//    func validateLogin() -> Bool {
//        if {
//            return true
//        } else {
//            return false
//        }
//    }

    @IBAction func login(_ sender: Any) {
        let def = UserDefaults.standard
        def.set(true, forKey: "is_loggedIn")
        def.set(2, forKey: "id")
        def.synchronize()
    }
    
     @IBAction func backToWelcome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
     }
}
