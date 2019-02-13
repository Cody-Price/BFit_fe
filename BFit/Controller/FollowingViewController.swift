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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followingView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        followingView.dataSource = self
        followingView.delegate = self
        

        // Do any additional setup after loading the view.
        setGradientBackground()
        populateFollowingTable()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(mockData.list[indexPath.row].userName)"
        return cell
    }
    
    
    func populateFollowingTable() {
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
