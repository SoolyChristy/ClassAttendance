//
//  HomeViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/13.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "首页"
        let addClassItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClassBtnAction))
        navigationItem.rightBarButtonItem = addClassItem
    }
}

extension HomeViewController {
    @objc private func addClassBtnAction() {
        navigationController?.pushViewController(CreatClassController(), animated: true)
    }
}
