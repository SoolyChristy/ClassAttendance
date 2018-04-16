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
        navigationBar.tintColor = mainColor
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
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        tabBarController?.tabBar.isHidden = false
        return super.popToRootViewController(animated: animated)
    }
    
    // 隐藏tabBar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if viewControllers.count > 1 {
            let backBtn = UIButton()
            backBtn.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            backBtn.addTarget(self, action: #selector(backItemAction), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    @objc private func backItemAction() {
        _ = popViewController(animated: true)
    }
}
