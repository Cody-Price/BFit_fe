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
        self.postsTable.rowHeight = 150.0
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
        
        thumbnail.image = userImage.image
        thumbnail.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        thumbnail.layer.masksToBounds = true
        thumbnail.layer.cornerRadius = 15
        thumbnail.frame.origin.x = 10
        thumbnail.frame.origin.y = 10
        
        title.text = "\(postsData[indexPath.row]["post"]["post_type"])".uppercased()
        title.textColor = UIColor(white: 1, alpha: 1)
        title.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        title.backgroundColor = UIColor(white: 1, alpha: 0)
        title.frame.origin.x = 50
        title.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)!
        title.frame.origin.y = 10
        
        subTitle.text = "\(postsData[indexPath.row]["post"]["title"])"
        subTitle.textColor = UIColor(white: 1, alpha: 1)
        subTitle.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        subTitle.backgroundColor = UIColor(white: 1, alpha: 0)
        subTitle.frame.origin.x = 50
        subTitle.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)!
        subTitle.frame.origin.y = 40
        
        cell.addSubview(title)
        cell.addSubview(thumbnail)
        cell.addSubview(subTitle)
        
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
