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
        data.append(User(name: "Bob", follow: false))
        data.append(User(name: "Bobby", follow: true))
        data.append(User(name: "Bobberton", follow: false))
        data.append(User(name: "Bobble", follow: false))
        data.append(User(name: "Bobert", follow: false))
    }
}
