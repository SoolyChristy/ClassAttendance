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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let c = ClassManager.shared.getAll() {
            classes = c
            todayClasses = ClassManager.shared.getToday(from: classes)
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
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
        tableView.separatorStyle = .none
        tableView.register(MyClassCell.self, forCellReuseIdentifier: kMyClassCellId)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private let tableView = UITableView()
    private var classes = [Class]()
    private var todayClasses = [Class]()
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
            return todayClasses.count
        case .myClass:
            return classes.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) ?? .max {
        case .today:
            return scale(iPhone8Design: 154)
        default:
            return scale(iPhone8Design: 154)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) ?? .max {
        case .today:
            let cell = tableView.dequeueReusableCell(withIdentifier: kMyClassCellId, for: indexPath) as! MyClassCell
            cell.update(model: todayClasses[indexPath.row], target: self, style: .today)
            return cell
        case .myClass:
            let cell = tableView.dequeueReusableCell(withIdentifier: kMyClassCellId, for: indexPath) as! MyClassCell
            cell.update(model: classes[indexPath.row], target: self, style: .normal)
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
            let weekLabel = UILabel()
            weekLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15), weight: .medium)
            view.addSubview(weekLabel)
            weekLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(view).inset(kBigTitleMargin)
                make.bottom.equalTo(label)
            })
            let week = weeks[getWeekDay() - 1]
            weekLabel.text = week
            label.text = "今日课程"
        case .myClass:
            label.text = "我的课程"
        default:
            break
        }
        label.sizeToFit()
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) ?? .max {
        case .today:
            let vc = ClassViewController(class: todayClasses[indexPath.row], style: .edit)
            navigationController?.pushViewController(vc, animated: true)
        case .myClass:
            let vc = ClassViewController(class: classes[indexPath.row], style: .edit)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    // 取消tableview section header黏性
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let kHeaderHeight: CGFloat = 28
        let y = scrollView.contentOffset.y
        if y <= kHeaderHeight && y >= 0 {
            scrollView.contentInset = UIEdgeInsets(top: -y, left: 0, bottom: 0, right: 0)
        } else if y >= kHeaderHeight {
            scrollView.contentInset = UIEdgeInsets(top: -kHeaderHeight, left: 0, bottom: 0, right: 0)
        }
    }
}
