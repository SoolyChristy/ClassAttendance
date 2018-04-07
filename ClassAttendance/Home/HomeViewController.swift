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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private let tableView = UITableView()
}

extension HomeViewController {
    @objc private func addClassBtnAction() {
        navigationController?.pushViewController(CreatClassController(), animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
