//
//  User.swift
//  BFit
//
//  Created by Cody Price on 2/13/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import Foundation

class User {
    let userName : String
    let isFollowing : Bool
    let id : Int
    
    init(name: String, follow: Bool, userId: Int) {
        userName = name
        isFollowing = follow
        id = userId
    }
}
