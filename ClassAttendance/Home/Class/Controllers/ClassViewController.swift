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

    public enum Style {
        case callTheRoll
        case normal
        case edit
    }
    
    init(class: Class, style: Style) {
        self.myClass = `class`
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        students = StudentManager.shared.get(with: myClass.students, classId: myClass.id)
        tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        title = myClass.lesson
        let rightBtn = UIButton()
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.setTitleColor(mainColor, for: .normal)
        rightBtn.setTitleColor(mainColor.withAlphaComponent(0.6), for: .highlighted)
        rightBtn.setTitleColor(mainColor.withAlphaComponent(0.6), for: .selected)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15))
        rightBtn.addTarget(self, action: #selector(doneBtnAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        headerView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kHeaderHeight)
        let backImageView = UIImageView.visualImageView(frame: headerView.bounds, imageName: myClass.icon)
        headerView.addSubview(backImageView)

        let iconView = UIImageView()
        iconView.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        iconView.addGestureRecognizer(longPress)
        iconView.image = UIImage(named: myClass.icon)
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
        tableView.tableFooterView = UIView()
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
    
    private let style: Style
    private var myClass: Class
    private var students = [Student]()
    private var attendance = [AttendanceType]()
    private lazy var callTheRollMgr: CallTheRollManager = CallTheRollManager(target: self, aClass: myClass)
    private let tableView = UITableView()
}

extension ClassViewController {

    @objc private func longPressAction() {
        myClass.students += StudentManager.shared.makeStudents()
        students = StudentManager.shared.get(with: myClass.students)
        tableView.reloadData()
    }

    @objc private func doneBtnAction() {
        switch style {
        case .normal:
            ClassManager.shared.creatClass(aClass: myClass) { (result) in
                switch result {
                case .success:
                    self.navigationController?.popToRootViewController(animated: true)
                case .failure(let error):
                    if error == .idRepeat {
                        self.view.makeToast("请勿重复创建课堂！")
                    } else {
                        self.view.makeToast("创建课堂失败！")
                    }
                }
            }
        case .edit:
            ClassManager.shared.update(myClass, compeletionHandler: { (result) in
                switch result {
                case .success:
                    self.navigationController?.popToRootViewController(animated: true)
                case .failure(_):
                    keyWindow?.makeToast("更新数据失败！")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        case .callTheRoll:
            callTheRollMgr.finishCall()
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc private func addBtnAction() {
        let addStudentVc = AddStudentController { (studentId) in
            self.myClass.students.append(studentId)
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(addStudentVc, animated: true)
    }
}

extension ClassViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myClass.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseId, for: indexPath) as! ClassStudentCell
        cell.delegate = callTheRollMgr
        cell.update(model: students[indexPath.row],
                    style: style,
                    attendanceType: style == .callTheRoll ? callTheRollMgr.attendanceTags[indexPath.row] : nil,
                    indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        students.remove(at: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! ClassStudentCell
        if let id = cell.student?.id,
            let index = myClass.students.index(of: id) {
            myClass.students.remove(at: index)
        }
        tableView.deleteRows(at: [indexPath], with: .left)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y > kHeaderHeight - kNavHeight {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
}
