//
//  BaseViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/13.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem()
        item.title = ""
        navigationItem.backBarButtonItem = item
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_back")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension BaseViewController {
    private func setupUI() {
        view.backgroundColor = .white
    }
}
