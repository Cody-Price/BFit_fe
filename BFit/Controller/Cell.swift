//
//  Cell.swift
//  BFit
//
//  Created by Cody Price on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel! 
    @IBOutlet weak var button: UIButton!

    func setCell(name: String) {
        username?.text = name
    }
}
