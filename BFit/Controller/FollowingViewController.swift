//
//  FollowingViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var followingView: UITableView!
    let mockData = FollowingMockData()
    var selectedId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.followingView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        followingView.dataSource = self
        followingView.delegate = self
        followingView.tableFooterView = UIView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let customButton = UIButton.init(type: .custom) as UIButton
        customButton.setTitle("Unfollow", for: .normal)
        customButton.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        customButton.layer.cornerRadius = 5
        customButton.layer.borderWidth = 1
        customButton.layer.borderColor = UIColor.white.cgColor
        customButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        cell.accessoryView = customButton as UIView
        cell.textLabel?.text = "\(mockData.list[indexPath.row].userName)"
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        cell.textLabel?.textColor = UIColor(white: 1, alpha: 1)
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
        selectedId = mockData.list[indexPath.row].id
        performSegue(withIdentifier: "showUser", sender: cell)
    }
    
    
    @objc func didButtonClick(_ sender: UIButton) {
        print("yay")
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
