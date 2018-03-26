//
//  NavViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/13.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    // 显示tabBar
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if viewControllers.count <= 2 {
            tabBarController?.tabBar.isHidden = false
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count <= 2 {
            tabBarController?.tabBar.isHidden = false
        }
        
        return super.popViewController(animated: animated)
    }
    
    // 隐藏tabBar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if viewControllers.count >= 2 {
            tabBarController?.tabBar.isHidden = true
        }
    }
}
