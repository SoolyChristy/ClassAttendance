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
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension BaseViewController {
    private func setupUI() {
        view.backgroundColor = .white
        if navigationController?.viewControllers.count ?? 0 > 1 {
            let backBtn = UIButton()
            backBtn.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            backBtn.addTarget(self, action: #selector(backItemAction), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
    }
    
    @objc private func backItemAction() {
        navigationController?.popViewController(animated: true)
    }
}
