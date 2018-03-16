//
//  MainViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/13.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildControllers()
    }
    
    private func addChildControllers() {
        let home = NavViewController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(title: "首页", image: nil, selectedImage: nil)
        let overview = NavViewController(rootViewController: BaseViewController())
        overview.tabBarItem = UITabBarItem(title: "一览", image: nil, selectedImage: nil)
        addChildViewController(home)
        addChildViewController(overview)
    }

}
