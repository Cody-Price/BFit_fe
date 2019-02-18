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
        list.append(User(name: "Jamie", follow: true, userId: 1))
        list.append(User(name: "Cody", follow: true, userId: 2))
        list.append(User(name: "Timmy", follow: true, userId: 3))
        list.append(User(name: "Nikki", follow: true, userId: 4))
        list.append(User(name: "DBag Jake", follow: true, userId: 5))
    }
}
