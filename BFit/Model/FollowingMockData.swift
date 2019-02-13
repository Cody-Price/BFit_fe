//
//  FollowingMockData.swift
//  BFit
//
//  Created by Cody Price on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import Foundation

class FollowingMockData {
    var list = [User]()
    
    init() {
        list.append(User(name: "Jamie", follow: true))
        list.append(User(name: "Cody", follow: true))
        list.append(User(name: "Timmy", follow: true))
        list.append(User(name: "Nikki", follow: true))
        list.append(User(name: "DBag Jake", follow: true))
    }
}
