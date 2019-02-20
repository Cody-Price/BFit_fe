//
//  HomeViewController.swift
//  BFit
//
//  Created by Cody Price on 2/17/19.
//  Copyright © 2019 Jamie Rushford. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // get feed data here
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // get feed data here
    }
    
//    func fetchFeed() {
//        
//    }
}

extension HomeViewController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
