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
        tabBar.tintColor = mainColor
        addChildControllers()
    }
    
    private func addChildControllers() {
        let home = NavViewController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(title: "首页", image: #imageLiteral(resourceName: "tabbar_home"), selectedImage: #imageLiteral(resourceName: "tabbar_home_select"))
        let overview = NavViewController(rootViewController: DetailViewController())
        overview.tabBarItem = UITabBarItem(title: "一览", image: #imageLiteral(resourceName: "tabbar_overview"), selectedImage: #imageLiteral(resourceName: "tabbar_overview"))
        addChildViewController(home)
        addChildViewController(overview)
    }

}
