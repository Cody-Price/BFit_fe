//
//  LoginViewController.swift
//  BFit
//
//  Created by Cody Price on 2/17/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        let def = UserDefaults.standard
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let is_loggedIn = def.bool(forKey: "is_loggedIn")
        if is_loggedIn {
            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
            self.present(homeViewController, animated: true, completion: nil)
        }
    }
    
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
}
