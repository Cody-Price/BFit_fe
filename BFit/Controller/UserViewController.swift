//
//  UserViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/17/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserViewController: UIViewController {

    @IBOutlet weak var btnStyle: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFeed: UITableView!
    
    
    var data = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        btnStyle.layer.cornerRadius = 5
        btnStyle.layer.borderWidth = 1
        btnStyle.layer.borderColor = UIColor.white.cgColor
        getUserData()
    }
    
    
    func getUserData() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(data)"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let data = JSON(response.data!)
                self.userImage.image = UIImage(named: data["user"]["avatar"].stringValue)
                self.userName.text = data["user"]["username"].stringValue
            } else {
                print("Failure")
            }
        }
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
    

    @IBAction func toggleFollow(_ sender: UIButton) {
        if sender.titleLabel!.text == "Follow" {
            sender.setTitle("Unfollow", for: .normal)
        } else {
            sender.setTitle("Follow", for: .normal)
        }
    }
}
