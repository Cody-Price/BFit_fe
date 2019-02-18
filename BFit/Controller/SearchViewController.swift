//
//  SearchViewController.swift
//  BFit
//
//  Created by Jamie Rushford on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    let mockSearchData = SearchData().data
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        searchTable.dataSource = self
        searchTable.delegate = self
        searchInput.delegate = self
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
        let searchValue = JSON(searchInput.text!)
        print(searchValue)
        searchInput.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockSearchData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as UITableViewCell
        let customButton = UIButton.init(type: .custom) as UIButton
        
        if mockSearchData[indexPath.row].isFollowing {
            customButton.setTitle("Unfollow", for: .normal)
        } else {
            customButton.setTitle("Follow", for: .normal)
        }
        
        customButton.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        customButton.layer.cornerRadius = 5
        customButton.layer.borderWidth = 1
        customButton.layer.borderColor = UIColor.white.cgColor
        customButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        cell.accessoryView = customButton as UIView
        
        cell.textLabel?.text = "\(mockSearchData[indexPath.row].userName)"
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        cell.textLabel?.textColor = UIColor(white: 1, alpha: 1)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "showUser", sender: cell)
    }
    
    
    @objc func didButtonClick(_ sender: UIButton) {
        if sender.titleLabel!.text == "Follow" {
            sender.setTitle("Unfollow", for: .normal)
        } else {
            sender.setTitle("Follow", for: .normal)
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
