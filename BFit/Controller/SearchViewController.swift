//
//  SearchViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON
import Cloudinary

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    let id = UserDefaults.standard.string(forKey: "id")!
    var selectedId : Int = 0
    var data : JSON = []
    var followingData : JSON = []
    var cleanedData : [Int] = []
    let config = CLDConfiguration(cloudName: "dykczjzsa", secure: true)
    lazy var cloudinary = CLDCloudinary(configuration: config)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        searchTable.dataSource = self
        searchTable.delegate = self
        searchInput.delegate = self
        searchTable.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFollowing()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchInput.setShowsCancelButton(true, animated: true)
        searchInput.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchInput.text = nil
        searchInput.showsCancelButton = false
        searchInput.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchValue = JSON(searchInput.text!.lowercased())
        if searchValue != "" {
            let urlString = "https://bfit-api.herokuapp.com/api/v1/users?username=\(searchValue)"
            Alamofire.request(urlString).responseJSON {
                response in
                if response.result.isSuccess {
                    self.data = JSON(response.data!)
                    self.getFollowing()
                } else {
                    let alert = UIAlertController(title: "Error", message: "Problem communicating with server during search.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            self.data = []
            self.getFollowing()
        }
        searchInput.endEditing(true)
    }
    
    func getFollowing() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/following"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                self.followingData = JSON(response.data!)
                self.cleanData()
                self.searchTable.reloadData()
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not fetch user data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func cleanData() {
        self.cleanedData = self.followingData.map { $0.1["users"]["id"].intValue }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        if cleanedData.contains(Int(data[indexPath.row]["users"]["id"].stringValue)!) {
            customButton.setTitle("Unfollow", for: .normal)
        } else {
            customButton.setTitle("Follow", for: .normal)
        }

        customButton.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        customButton.frame.origin.x = self.view!.bounds.width - 140
        customButton.frame.origin.y = 7
        customButton.layer.cornerRadius = 5
        customButton.layer.borderWidth = 1
        customButton.layer.borderColor = UIColor.white.cgColor
        customButton.tag = Int(data[indexPath.row]["users"]["id"].stringValue)!
        customButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        
        textLabel.text = "\(data[indexPath.row]["users"]["username"].stringValue)"
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
        if sender.titleLabel!.text == "Follow" {
            let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/follow/\(sender.tag)"
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
            let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/unfollow/\(sender.tag)"
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
