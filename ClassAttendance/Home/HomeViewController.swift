//
//  HomeViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/13.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

private let kMyClassCellId = "home.myclass.id"

class HomeViewController: BaseViewController {

    enum Section: Int {
        case today = 0
        case myClass
        case max
        
        func title() -> String {
            switch self {
            case .today:
                return "今日课程"
            case .myClass:
                return "我的课堂"
            default:
                return ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "首页"
        let addClassItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClassBtnAction))
        navigationItem.rightBarButtonItem = addClassItem
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: 1, height: kBigTitleMargin)
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.register(MyClassCell.self, forCellReuseIdentifier: kMyClassCellId)
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
        return Section.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) ?? .max {
        case .today:
            return 1
        case .myClass:
            return 10
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) ?? .max {
        case .today:
            return 44
        default:
            return scale(iPhone8Design: 154)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) ?? .max {
        case .today:
            return UITableViewCell()
        case .myClass:
            let cell = tableView.dequeueReusableCell(withIdentifier: kMyClassCellId, for: indexPath) as! MyClassCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = tableView.backgroundColor
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: scale(iPhone8Design: 40))
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 18), weight: .medium)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view).inset(kBigTitleMargin)
            make.centerY.equalTo(view)
        }
        switch Section(rawValue: section) ?? .max {
        case .today:
            label.text = "今日课程"
        case .myClass:
            label.text = "我的课程"
        default:
            break
        }
        label.sizeToFit()
        return view
    }
}
