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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        imagePicker.delegate = self
        postsTable.delegate = self
        postsTable.dataSource = self
        postsTable.tableFooterView = UIView()
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
                self.postsData = JSON(response.data!)["posts"]
                print(self.postsData)
//                self.postsTable.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as UITableViewCell
        let title = UILabel.init() as UILabel

//        title.text = "\(postsData[indexPath].title)"
        title.textColor = UIColor(white: 1, alpha: 1)
        title.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        title.backgroundColor = UIColor(white: 1, alpha: 0)
        title.frame.origin.x = 50
        title.font = UIFont.systemFont(ofSize: 18.0)
        title.frame.origin.y = 7
        
        
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
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profilePic.image = pickedImage
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
//                    self.patchUserWithImage(url: url)
                } else if (error != nil) {
                    let alert = UIAlertController(title: "Error", message: "Could not fetch upload image", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            })
    }
    
    func patchUserWithImage(url : String) {
        let urlString = "https://bfit-api.herokuapp.com/api/v1/users"
        let data = [
            "avatar" : url
        ]
        
        Alamofire.request(urlString, method: .patch, parameters: data, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                self.profilePic.cldSetImage(self.cloudinary.createUrl().generate(url)!, cloudinary: self.cloudinary)
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
