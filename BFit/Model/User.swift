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
    
    init(name: String, follow: Bool) {
        userName = name
        isFollowing = follow
    }
}
