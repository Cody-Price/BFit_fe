//
//  FollowingViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit
import Cloudinary
import Alamofire
import SwiftyJSON

class FollowingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var followingView: UITableView!
    let id = UserDefaults.standard.string(forKey: "id")!
    var selectedId : Int = 0
    let config = CLDConfiguration(cloudName: "dykczjzsa", secure: true)
    lazy var cloudinary = CLDCloudinary(configuration: config)
    var data : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.followingView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        followingView.dataSource = self
        followingView.delegate = self
        followingView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFollowing()
    }
    
    func getFollowing() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/following"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                self.data = JSON(response.data!)
                self.followingView.reloadData()
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not fetch user data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numFollowing.text = "\(data.count) Following"
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        let customButton = UIButton.init(type: .custom) as UIButton
        let thumbnail = UIImageView.init() as UIImageView
        let textLabel = UILabel.init() as UILabel
        let url = data[indexPath.row]["users"]["avatar"].stringValue
        thumbnail.cldSetImage(self.cloudinary.createUrl().generate(url)!, cloudinary: self.cloudinary)
        thumbnail.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        thumbnail.layer.masksToBounds = true
        thumbnail.layer.cornerRadius = 15
        thumbnail.frame.origin.x = 10
        thumbnail.frame.origin.y = 7
        
        customButton.setTitle("Unfollow", for: .normal)
        customButton.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        customButton.frame.origin.x = self.view!.bounds.width - 140
        customButton.frame.origin.y = 7
        customButton.layer.cornerRadius = 5
        customButton.layer.borderWidth = 1
        customButton.layer.borderColor = UIColor.white.cgColor
        customButton.tag = Int(data[indexPath.row]["users"]["id"].stringValue)!
        customButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        
        textLabel.text = "\(data[indexPath.row]["users"]["username"])"
        textLabel.textColor = UIColor(white: 1, alpha: 1)
        textLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        textLabel.backgroundColor = UIColor(white: 1, alpha: 0)
        textLabel.frame.origin.x = 50
        textLabel.font = UIFont.systemFont(ofSize: 18.0)
        textLabel.frame.origin.y = 7
        
        cell.addSubview(thumbnail)
        cell.addSubview(customButton)
        cell.addSubview(textLabel)
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser" {
            let userVC = segue.destination as! UserViewController
            userVC.data = String(selectedId)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        selectedId = Int(data[indexPath.row]["users"]["id"].stringValue)!
        performSegue(withIdentifier: "showUser", sender: cell)
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/unfollow/\(sender.tag)"
        Alamofire.request(url, method: .post).responseJSON {
            response in
            if response.result.isSuccess {
                self.getFollowing()
            } else {
                let alert = UIAlertController(title: "Error", message: "Problem communicating with server.", preferredStyle: .alert)
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
    
    @IBAction func backToProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
