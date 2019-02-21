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
import Cloudinary

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postsTable: UITableView!
    @IBOutlet weak var btnStyle: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFeed: UITableView!
    let id = UserDefaults.standard.string(forKey: "id")!
    let config = CLDConfiguration(cloudName: "dykczjzsa", secure: true)
    lazy var cloudinary = CLDCloudinary(configuration: config)
    var postsData : JSON = []
    var followingData : JSON = []
    var cleanedData : [Int] = []
    
    var data = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        postsTable.delegate = self
        postsTable.dataSource = self
        self.postsTable.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")
        self.postsTable.rowHeight = 200.0
        postsTable.tableFooterView = UIView()
        btnStyle.layer.cornerRadius = 5
        btnStyle.layer.borderWidth = 1
        btnStyle.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserData()
        getUserPosts()
        getFollowing()
    }
    
    func getUserData() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(data)"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let data = JSON(response.data!)
                let url = data["user"]["avatar"].stringValue
                self.userImage.cldSetImage(self.cloudinary.createUrl().generate(url)!, cloudinary: self.cloudinary)
                self.userName.text = data["user"]["username"].stringValue
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not fetch user data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getUserPosts() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(data)/posts"
        Alamofire.request(url).responseJSON {
            response in
            if response.result.isSuccess {
                self.postsData = JSON(response.data!)
                self.postsTable.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not fetch user data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getFollowing() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/following"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                self.followingData = JSON(response.data!)
                self.cleanData()
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not fetch user data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func cleanData() {
        cleanedData = followingData.map { $0.1["users"]["id"].intValue }
        if cleanedData.contains(Int(data)!) {
            btnStyle.setTitle("Unfollow", for: .normal)
        } else {
            btnStyle.setTitle("Follow", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        let title = UILabel.init() as UILabel
        let thumbnail = UIImageView.init() as UIImageView
        let subTitle = UILabel.init() as UILabel
        let contentTitleOne = UILabel.init() as UILabel
        let contentTitleTwo = UILabel.init() as UILabel
        thumbnail.image = userImage.image
        thumbnail.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        thumbnail.layer.masksToBounds = true
        thumbnail.layer.cornerRadius = 15
        thumbnail.frame.origin.x = 12
        thumbnail.frame.origin.y = 18
        
        title.text = "\(postsData[indexPath.row]["username"])"
        title.textColor = UIColor(white: 1, alpha: 1)
        title.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        title.backgroundColor = UIColor(white: 1, alpha: 0)
        title.frame.origin.x = 50
        title.font = UIFont(name: "HelveticaNeue", size: 22.0)!
        title.frame.origin.y = 13
        
        if postsData[indexPath.row]["post"]["post_type"] == "exercise" {
            subTitle.text = "\(postsData[indexPath.row]["post"]["exercise"]["name"])"
            subTitle.text = subTitle.text! + " - \(postsData[indexPath.row]["post"]["exercise"]["muscle_group"])"
        } else {
            subTitle.text = "\(postsData[indexPath.row]["post"]["meal"]["name"])"
        }
        subTitle.textColor = UIColor(white: 1, alpha: 1)
        subTitle.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        subTitle.backgroundColor = UIColor(white: 1, alpha: 0)
        subTitle.frame.origin.x = 50
        subTitle.font = UIFont(name: "HelveticaNeue", size: 16.0)!
        subTitle.frame.origin.y = 35
        
        if postsData[indexPath.row]["post"]["post_type"] == "exercise" {
            if postsData[indexPath.row]["post"]["exercise"]["muscle_group"] == "Cardio" {
                contentTitleOne.text = "Time: "
                contentTitleTwo.text = "Distance: "
            } else {
                contentTitleOne.text = "Weight: "
                contentTitleTwo.text = "Reps: "
            }
        } else {
            contentTitleOne.text = "Food: "
            contentTitleTwo.text = "Calories: "
        }
        
        contentTitleOne.textColor = UIColor(white: 1, alpha: 1)
        contentTitleOne.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        contentTitleOne.backgroundColor = UIColor(white: 1, alpha: 0)
        contentTitleOne.frame.origin.x = 50
        contentTitleOne.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)!
        contentTitleOne.frame.origin.y = 60
        
        contentTitleTwo.textColor = UIColor(white: 1, alpha: 1)
        contentTitleTwo.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        contentTitleTwo.backgroundColor = UIColor(white: 1, alpha: 0)
        contentTitleTwo.frame.origin.x = 220
        contentTitleTwo.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)!
        contentTitleTwo.frame.origin.y = 60
        
        for i in 1...5 {
            let label = UILabel.init() as UILabel
            if postsData[indexPath.row]["post"]["post_type"] == "exercise" {
                if postsData[indexPath.row]["post"]["exercise"]["weight"].stringValue != "" {
                    label.text = "\(postsData[indexPath.row]["post"]["exercise"]["weight"])"
                } else {
                    label.text = "\(postsData[indexPath.row]["post"]["exercise"]["time"])"
                }
                label.font = UIFont(name: "HelveticaNeue", size: 40.0)!
                label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
                label.frame.origin.x = 70
                label.frame.origin.y = CGFloat(i * 20 + 85)
            } else {
                if postsData[indexPath.row]["post"]["meal"]["foods"][i - 1]["name"].stringValue == "" {
                    label.text = nil
                } else {
                    label.text = "\(postsData[indexPath.row]["post"]["meal"]["foods"][i - 1]["name"])"
                }
                label.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
                label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
                label.frame.origin.x = 50
                label.frame.origin.y = CGFloat(i * 20 + 65)
            }
            label.textColor = UIColor(white: 1, alpha: 1)
            label.backgroundColor = UIColor(white: 1, alpha: 0)
            if postsData[indexPath.row]["post"]["post_type"] == "exercise" && i == 1 {
                cell.addSubview(label)
            } else if postsData[indexPath.row]["post"]["post_type"] == "meal" {
                cell.addSubview(label)
            }
        }
        
        for i in 1...5 {
            let label = UILabel.init() as UILabel
            let stringValue = postsData[indexPath.row]["post"]["meal"]["foods"][i - 1]["calories"].stringValue
            if postsData[indexPath.row]["post"]["post_type"] == "exercise" {
                if postsData[indexPath.row]["post"]["exercise"]["reps"].stringValue != "" {
                    label.text = "\(postsData[indexPath.row]["post"]["exercise"]["reps"])"
                } else {
                    label.text = "\(postsData[indexPath.row]["post"]["exercise"]["time"])"
                }
                label.font = UIFont(name: "HelveticaNeue", size: 40.0)!
                label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
                label.frame.origin.x = 240
                label.frame.origin.y = CGFloat(i * 20 + 85)
            } else {
                if stringValue == "" || stringValue == "0" {
                    label.text = nil
                } else {
                    label.text = "\(postsData[indexPath.row]["post"]["meal"]["foods"][i - 1]["calories"])"
                    label.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
                    label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
                    label.frame.origin.x = 220
                    label.frame.origin.y = CGFloat(i * 20 + 65)
                }
            }
            label.textColor = UIColor(white: 1, alpha: 1)
            label.backgroundColor = UIColor(white: 1, alpha: 0)
            if postsData[indexPath.row]["post"]["post_type"] == "exercise" && i == 1 {
                cell.addSubview(label)
            } else if postsData[indexPath.row]["post"]["post_type"] == "meal" {
                cell.addSubview(label)
            }
        }
        
        cell.addSubview(title)
        cell.addSubview(thumbnail)
        cell.addSubview(subTitle)
        cell.addSubview(contentTitleOne)
        cell.addSubview(contentTitleTwo)
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
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
            let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/follow/\(data)"
            Alamofire.request(url, method: .post).responseJSON {
                response in
                if response.result.isSuccess {
                    sender.setTitle("Unfollow", for: .normal)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Problem communicating with server.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/unfollow/\(data)"
            Alamofire.request(url, method: .post).responseJSON {
                response in
                if response.result.isSuccess {
                    sender.setTitle("Follow", for: .normal)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Problem communicating with server.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
