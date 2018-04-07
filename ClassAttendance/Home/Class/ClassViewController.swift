//
//  ClassViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/27.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

private let kReuseId = "class.student.cell"
private let kHeaderHeight = scale(iPhone8Design: 240)

class ClassViewController: BaseViewController {

    init(class: Class) {
        self.myClass = `class`
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let s1 = Student(name: "罗建武", id: 201421091024, phone: 1316666, icon: "ic_boy", sex: .male, late: nil, absenteeism: nil, earlyLeave: nil, leave: nil)
        let s2 = Student(name: "罗建武", id: 201421091024, phone: 1316666, icon: "ic_boy", sex: .male, late: nil, absenteeism: nil, earlyLeave: nil, leave: nil)
        let s3 = Student(name: "罗建武", id: 201421091024, phone: 1316666, icon: "ic_boy", sex: .male, late: nil, absenteeism: nil, earlyLeave: nil, leave: nil)
        students = [s1, s2, s3]
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        title = "编译原理"
        let rightBtn = UIButton()
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.setTitleColor(mainColor, for: .normal)
        rightBtn.setTitleColor(mainColor.withAlphaComponent(0.6), for: .highlighted)
        rightBtn.setTitleColor(mainColor.withAlphaComponent(0.6), for: .selected)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15))
        rightBtn.addTarget(self, action: #selector(doneBtnAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        let iconImage = UIImage(named: myClass.icon)
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        headerView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kHeaderHeight)
        let backImageView = UIImageView()
        backImageView.image = iconImage
        backImageView.frame = headerView.bounds
        let blurEffect = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.frame = backImageView.bounds
        backImageView.addSubview(visualView)
        headerView.addSubview(backImageView)

        let iconView = UIImageView()
        iconView.image = iconImage
        headerView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView).offset(kNavHeight + scale(iPhone8Design: 16))
            make.left.equalTo(scale(iPhone8Design: 16))
            make.height.width.equalTo(scale(iPhone8Design: 71))
        }
        let nameLabel = UILabel()
        nameLabel.text = myClass.lesson
        nameLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 17), weight: .bold)
        nameLabel.textColor = .black
        headerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(scale(iPhone8Design: 16))
            make.top.equalTo(iconView)
        }
        let classNameLabel = UILabel()
        classNameLabel.text = myClass.name
        classNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        classNameLabel.textColor = .black
        headerView.addSubview(classNameLabel)
        classNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(scale(iPhone8Design: 2))
        }
        let timeLabel = UILabel()
        timeLabel.text = ClassTimeManager().classDatesToString(classDates: myClass.dates)
        timeLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        timeLabel.textColor = .darkGray
        headerView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(classNameLabel.snp.bottom).offset(scale(iPhone8Design: 2))
        }
        
        let addBtn = UIButton.customButton(title: "添加学生",
                                           size: CGSize(width: scale(iPhone8Design: 280),
                                                        height: scale(iPhone8Design: 32)))
        addBtn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        headerView.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(kTextFieldMargin)
            make.centerX.equalTo(headerView)
        }
        
        tableView.register(ClassStudentCell.self, forCellReuseIdentifier: kReuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.tableHeaderView = headerView
        tableView.rowHeight = scale(iPhone8Design: 60)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    private var myClass: Class
    private var students = [Student]()
    private let tableView = UITableView()
}

extension ClassViewController {
    
    @objc private func doneBtnAction() {
        myClass.students = students
        DatabaseManager.shared.creatClass(aClass: myClass) { (result) in
            switch result {
            case .success:
                break
            case .failure(let error):
                if error == .idRepeat {
                    self.view.makeToast("请勿重复创建课堂！")
                } else {
                    self.view.makeToast("创建课堂失败！")
                }
            }
        }
    }
    
    @objc private func addBtnAction() {
        let addStudentVc = AddStudentController { (student) in
            self.students.append(student)
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(addStudentVc, animated: true)
    }
}

extension ClassViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseId, for: indexPath) as? ClassStudentCell
        cell?.update(model: students[indexPath.row])
        return cell ?? ClassStudentCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        navigationController?.setNavigationBarHidden(translation.y < 0, animated: true)
//    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        navigationController?.setNavigationBarHidden(velocity.y > 0, animated: true)
    }
    
}
