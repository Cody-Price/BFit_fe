//
//  ViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/11/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cloudinary

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let config = CLDConfiguration(cloudName: "dykczjzsa", secure: true)
    lazy var cloudinary = CLDCloudinary(configuration: config)
    lazy var feedData : JSON = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")
//        fetchFeed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        fetchFeed()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return feedData.list.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        let thumbnail = UIImageView.init() as UIImageView
        let textLabel = UILabel.init() as UILabel
        thumbnail.cldSetImage(self.cloudinary.createUrl().generate("fwdyfioiphjx1rhhovd2.jpg")!, cloudinary: self.cloudinary)
        thumbnail.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        thumbnail.layer.masksToBounds = true
        thumbnail.layer.cornerRadius = 15
        thumbnail.frame.origin.x = 10
        thumbnail.frame.origin.y = 7
        textLabel.text = "hello world"
        //        textLabel.text = "\(mockData.list[indexPath.row].username)"
        textLabel.textColor = UIColor(white: 1, alpha: 1)
        textLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        textLabel.backgroundColor = UIColor(white: 1, alpha: 0)
        textLabel.frame.origin.x = 50
        textLabel.font = UIFont.systemFont(ofSize: 18.0)
        textLabel.frame.origin.y = 7
        
        cell.addSubview(thumbnail)
        cell.addSubview(textLabel)
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        return cell
    }
    
    func fetchFeed() {
        let url = "https://bfit-api.herokuapp.com/api/v1/feed"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let data = JSON(response.data!)
                self.feedData = data
                print(data)
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not fetch feed data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
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
}

