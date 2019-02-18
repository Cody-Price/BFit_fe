//
//  SearchData.swift
//  BFit
//
//  Created by Jamie Rushford on 2/14/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import Foundation

class SearchData {
    var data : [User] = [User]()
    
    init() {
        data.append(User(name: "Bob", follow: false, userId: 1))
        data.append(User(name: "Bobby", follow: true, userId: 2))
        data.append(User(name: "Bobberton", follow: false, userId: 3))
        data.append(User(name: "Bobble", follow: false, userId: 4))
        data.append(User(name: "Bobert", follow: false, userId: 5))
    }
}
