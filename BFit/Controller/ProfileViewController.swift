//
//  ProfileViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/11/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cloudinary

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var postsTable: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    let imagePicker = UIImagePickerController()
    let id = UserDefaults.standard.string(forKey: "id")!
    let config = CLDConfiguration(cloudName: "dykczjzsa", secure: true)
    lazy var cloudinary = CLDCloudinary(configuration: config)
    var postsData : JSON = []
    var image : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        imagePicker.delegate = self
        postsTable.delegate = self
        postsTable.dataSource = self
        self.postsTable.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")
        self.postsTable.rowHeight = 200.0
        postsTable.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCurrentUser()
        getUserPosts()
    }
    
    func getCurrentUser() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let data = JSON(response.data!)
                let url = data["user"]["avatar"].stringValue
                self.image = url
                self.profilePic.cldSetImage(self.cloudinary.createUrl().generate(url)!, cloudinary: self.cloudinary)
                self.userName.text = data["user"]["username"].stringValue
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not fetch user data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getUserPosts() {
        let url = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/posts"
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
        
        thumbnail.cldSetImage(self.cloudinary.createUrl().generate(self.image)!, cloudinary: self.cloudinary)
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
        title.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)!
        title.frame.origin.y = 10
        
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
        subTitle.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)!
        subTitle.frame.origin.y = 30
        
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
        contentTitleTwo.frame.origin.x = 200
        contentTitleTwo.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)!
        contentTitleTwo.frame.origin.y = 60
        
        for i in 1...5 {
            let label = UILabel.init() as UILabel
            if postsData[indexPath.row]["post"]["post_type"] == "exercise" {
                if postsData[indexPath.row]["post"]["exercise"]["weight"] != "null" {
                    label.text = "\(postsData[indexPath.row]["post"]["exercise"]["weight"])"
                } else {
                    label.text = "\(postsData[indexPath.row]["post"]["exercise"]["time"])"
                }
            } else {
                if postsData[indexPath.row]["post"]["meal"]["foods"][i - 1]["name"].stringValue == "" {
                    label.text = nil
                } else {
                    label.text = "\(postsData[indexPath.row]["post"]["meal"]["foods"][i - 1]["name"])"
                }
            }
            label.textColor = UIColor(white: 1, alpha: 1)
            label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
            label.backgroundColor = UIColor(white: 1, alpha: 0)
            label.frame.origin.x = 50
            label.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
            label.frame.origin.y = CGFloat(i * 20 + 65)
            if postsData[indexPath.row]["post"]["post_type"] == "exercise" && i == 1 {
                cell.addSubview(label)
            } else if postsData[indexPath.row]["post"]["post_type"] == "meal" {
                cell.addSubview(label)
            }
        }
        
        for i in 1...5 {
            let label = UILabel.init() as UILabel
            if postsData[indexPath.row]["post"]["post_type"] == "exercise" {
                if postsData[indexPath.row]["post"]["exercise"]["reps"] != "null" {
                    label.text = "\(postsData[indexPath.row]["post"]["exercise"]["reps"])"
                } else {
                    label.text = "\(postsData[indexPath.row]["post"]["exercise"]["time"])"
                }
            } else {
                if postsData[indexPath.row]["post"]["meal"]["foods"][i - 1]["calories"].stringValue == "" {
                    label.text = nil
                } else {
                    label.text = "\(postsData[indexPath.row]["post"]["meal"]["foods"][i - 1]["calories"])"
                }
            }
            label.textColor = UIColor(white: 1, alpha: 1)
            label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
            label.backgroundColor = UIColor(white: 1, alpha: 0)
            label.frame.origin.x = 200
            label.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
            label.frame.origin.y = CGFloat(i * 20 + 65)
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
    
    
    @IBAction func logout(_ sender: Any) {
        let def = UserDefaults.standard
        def.set(false, forKey: "is_loggedIn")
        def.set(nil, forKey: "id")
        def.synchronize()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "Welcome") as! WelcomeViewController
        self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    @IBAction func addProfilePic(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        postImage(imgURL: imageURL as URL)
        dismiss(animated: true, completion: nil)
    }
    
    func postImage(imgURL : URL) {
        cloudinary.createUploader().upload(url: imgURL, uploadPreset: "rgflevhw")
            .response({ (response, error) in
                if let result = response {
                    let publicID = result.publicId!
                    let format = result.format!
                    let url = "\(publicID).\(format)"
                    self.image = url
                    self.patchUserWithImage(url: url)
                } else if (error != nil) {
                    let alert = UIAlertController(title: "Error", message: "Could not fetch upload image", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            })
    }
    
    func patchUserWithImage(url : String) {
        let urlString = "https://bfit-api.herokuapp.com/api/v1/users/\(id)/edit"
        let data = [
            "avatar" : url
        ]
        
        Alamofire.request(urlString, method: .put, parameters: data, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                self.profilePic.cldSetImage(self.cloudinary.createUrl().generate(url)!, cloudinary: self.cloudinary)
                self.postsTable.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not post new image to user specified", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
