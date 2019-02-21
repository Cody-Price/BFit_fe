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
    
    
    @IBOutlet weak var feedTable: UITableView!
    let id = UserDefaults.standard.string(forKey: "id")!
    let config = CLDConfiguration(cloudName: "dykczjzsa", secure: true)
    lazy var cloudinary = CLDCloudinary(configuration: config)
    var feedData : JSON = []
    var image : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        feedTable.delegate = self
        feedTable.dataSource = self
        self.feedTable.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")
        self.feedTable.rowHeight = 200.0
        feedTable.tableFooterView = UIView()
        getFeedPosts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFeedPosts()
        if feedData.count == 0 {
            feedTable.separatorColor = UIColor(white: 1, alpha: 0)
        } 
    }
    
    func getFeedPosts() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/feed"
        Alamofire.request(url).responseJSON {
            response in
            if response.result.isSuccess {
                self.feedData = JSON(response.data!)
                self.feedTable.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not fetch feed data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if feedData.count > 0 {
            return feedData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if feedData.count > 0 {
            let cell = UITableViewCell.init()
            let title = UILabel.init() as UILabel
            let thumbnail = UIImageView.init() as UIImageView
            let subTitle = UILabel.init() as UILabel
            let contentTitleOne = UILabel.init() as UILabel
            let contentTitleTwo = UILabel.init() as UILabel
            let url = feedData[indexPath.row]["avatar"].stringValue
            thumbnail.cldSetImage(self.cloudinary.createUrl().generate(url)!, cloudinary: self.cloudinary)
            thumbnail.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            thumbnail.layer.masksToBounds = true
            thumbnail.layer.cornerRadius = 15
            thumbnail.frame.origin.x = 12
            thumbnail.frame.origin.y = 18
            
            title.text = "\(feedData[indexPath.row]["username"])"
            title.textColor = UIColor(white: 1, alpha: 1)
            title.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
            title.backgroundColor = UIColor(white: 1, alpha: 0)
            title.frame.origin.x = 50
            title.font = UIFont(name: "HelveticaNeue", size: 22.0)!
            title.frame.origin.y = 13
            
            if feedData[indexPath.row]["post"]["post_type"] == "exercise" {
                subTitle.text = "\(feedData[indexPath.row]["post"]["exercise"]["name"])"
                subTitle.text = subTitle.text! + " - \(feedData[indexPath.row]["post"]["exercise"]["muscle_group"])"
            } else {
                subTitle.text = "\(feedData[indexPath.row]["post"]["meal"]["name"])"
            }
            subTitle.textColor = UIColor(white: 1, alpha: 1)
            subTitle.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
            subTitle.backgroundColor = UIColor(white: 1, alpha: 0)
            subTitle.frame.origin.x = 50
            subTitle.font = UIFont(name: "HelveticaNeue", size: 16.0)!
            subTitle.frame.origin.y = 35
            
            if feedData[indexPath.row]["post"]["post_type"] == "exercise" {
                if feedData[indexPath.row]["post"]["exercise"]["muscle_group"] == "Cardio" {
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
                if feedData[indexPath.row]["post"]["post_type"] == "exercise" {
                    if feedData[indexPath.row]["post"]["exercise"]["weight"].stringValue != "" {
                        label.text = "\(feedData[indexPath.row]["post"]["exercise"]["weight"])"
                    } else {
                        label.text = "\(feedData[indexPath.row]["post"]["exercise"]["time"])"
                    }
                    label.font = UIFont(name: "HelveticaNeue", size: 40.0)!
                    label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
                    label.frame.origin.x = 70
                    label.frame.origin.y = CGFloat(i * 20 + 85)
                } else {
                    if feedData[indexPath.row]["post"]["meal"]["foods"][i - 1]["name"].stringValue == "" {
                        label.text = nil
                    } else {
                        label.text = "\(feedData[indexPath.row]["post"]["meal"]["foods"][i - 1]["name"])"
                    }
                    label.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
                    label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
                    label.frame.origin.x = 50
                    label.frame.origin.y = CGFloat(i * 20 + 65)
                }
                label.textColor = UIColor(white: 1, alpha: 1)
                label.backgroundColor = UIColor(white: 1, alpha: 0)
                if feedData[indexPath.row]["post"]["post_type"] == "exercise" && i == 1 {
                    cell.addSubview(label)
                } else if feedData[indexPath.row]["post"]["post_type"] == "meal" {
                    cell.addSubview(label)
                }
            }
            
            for i in 1...5 {
                let label = UILabel.init() as UILabel
                let stringValue = feedData[indexPath.row]["post"]["meal"]["foods"][i - 1]["calories"].stringValue
                if feedData[indexPath.row]["post"]["post_type"] == "exercise" {
                    if feedData[indexPath.row]["post"]["exercise"]["reps"].stringValue != "" {
                        label.text = "\(feedData[indexPath.row]["post"]["exercise"]["reps"])"
                    } else {
                        label.text = "\(feedData[indexPath.row]["post"]["exercise"]["time"])"
                    }
                    label.font = UIFont(name: "HelveticaNeue", size: 40.0)!
                    label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
                    label.frame.origin.x = 240
                    label.frame.origin.y = CGFloat(i * 20 + 85)
                } else {
                    if stringValue == "" || stringValue == "0" {
                        label.text = nil
                    } else {
                        label.text = "\(feedData[indexPath.row]["post"]["meal"]["foods"][i - 1]["calories"])"
                        label.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
                        label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
                        label.frame.origin.x = 220
                        label.frame.origin.y = CGFloat(i * 20 + 65)
                    }
                }
                label.textColor = UIColor(white: 1, alpha: 1)
                label.backgroundColor = UIColor(white: 1, alpha: 0)
                if feedData[indexPath.row]["post"]["post_type"] == "exercise" && i == 1 {
                    cell.addSubview(label)
                } else if feedData[indexPath.row]["post"]["post_type"] == "meal" {
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
        } else {
            let cell = UITableViewCell.init()
            let title = UILabel.init() as UILabel
            title.text = "Search & Follow other users to populate your feed!"
            title.textColor = UIColor(white: 1, alpha: 1)
            title.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
            title.numberOfLines = 0
            title.backgroundColor = UIColor(white: 1, alpha: 0)
            title.frame.origin.x = 50
            title.font = UIFont(name: "HelveticaNeue", size: 22.0)!
            title.frame.origin.y = 13
            cell.addSubview(title)
            cell.backgroundColor = UIColor(white: 1, alpha: 0)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
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
