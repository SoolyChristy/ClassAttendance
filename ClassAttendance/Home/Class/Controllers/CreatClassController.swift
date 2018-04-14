//
//  CreatClassViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/18.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

private let kRowHeight: CGFloat = 64
private let kReuseId = "creatClass.id"

class CreatClassController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "新建课堂"

        let iconBtn = UIButton.iconButton()
        iconBtn.addTarget(self, action: #selector(iconBtnAction), for: .touchUpInside)
        view.addSubview(iconBtn)
        iconBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(scale(iPhone8Design: 20))
            make.centerX.equalTo(view)
        }
        
        nameFiled.placehoderLabel.text = "班级名称"
        nameFiled.setStatusDidChanged(self) { (weakSelf, text) in
            weakSelf.nextBtn.isEnabled = (!text.isEmpty && !(weakSelf.lessonFiled.text ?? "").isEmpty) ? true : false
        }
        view.addSubview(nameFiled)
        nameFiled.snp.makeConstraints { (make) in
            make.top.equalTo(iconBtn.snp.bottom).offset(kTextFieldMargin)
            make.centerX.equalTo(view)
            make.width.equalTo(scale(iPhone8Design: 180))
            make.height.equalTo(scale(iPhone8Design: 17))
        }
        
        lessonFiled.placehoderLabel.text = "课程名称"
        lessonFiled.setStatusDidChanged(self) { (weakSelf, text) in
            weakSelf.nextBtn.isEnabled = (!text.isEmpty && !(weakSelf.nameFiled.text ?? "").isEmpty) ? true : false
        }
        view.addSubview(lessonFiled)
        lessonFiled.snp.makeConstraints { (make) in
            make.top.equalTo(nameFiled.snp.bottom).offset(kTextFieldMargin)
            make.centerX.equalTo(view)
            make.width.equalTo(nameFiled)
            make.height.equalTo(nameFiled)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.rowHeight = scale(iPhone8Design: kRowHeight)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(lessonFiled.snp.bottom).offset(kTextFieldMargin)
            make.left.right.equalTo(view)
            make.height.equalTo(scale(iPhone8Design: 220))
        }
        
        
        nextBtn.isEnabled = false
        nextBtn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(kCustomButtonMargin)
            make.centerX.equalTo(view)
        }
    }
    
    fileprivate let nameFiled = TextFiledView.textFiledView()
    fileprivate let lessonFiled = TextFiledView.textFiledView()
    fileprivate let nextBtn = UIButton.customButton(title: "下一步")
    private let tableView = UITableView()
    private var dates = [ClassDate]()
    private let classTimeMgr = ClassTimeManager()
}

extension CreatClassController {
    @objc private func nextBtnAction() {
        guard dates.count > 0 else {
            view.makeToast("请选择课堂时间")
            return
        }
        guard let name = nameFiled.text,
            let lesson = lessonFiled.text else {
                return
        }
        
        let `class` = Class(name: name, lesson: lesson, icon: "ic_defalut_class", dates: dates, students: [ID]())
        navigationController?.pushViewController(ClassViewController(class: `class`, style: .normal), animated: true)
    }
    
    @objc private func iconBtnAction() {
        let alert = UIAlertController(style: .actionSheet)
        alert.addPhotoLibraryPicker(
            flow: .horizontal,
            paging: true,
            selection: .single(action: { image in
                
            }))
        alert.addAction(title: "取消", style: .cancel)
        alert.show()
    }
    
    @objc private func addBtnAction() {
        classTimeMgr.showClassTimePicker { [weak self] (classDate) in
            self?.dates.append(classDate)
            self?.tableView.reloadData()
        }
    }
}

extension CreatClassController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: kReuseId)
        cell.accessoryType = .disclosureIndicator
        let classDate = dates[indexPath.row]
        let classTime = classTimeMgr.classDateToString(classDate: classDate)
        cell.textLabel?.text = classTime.week
        cell.detailTextLabel?.text = classTime.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        classTimeMgr.showClassTimePicker(defaultClassDate: dates[indexPath.row]) { [weak self] (classDate) in
            self?.dates[indexPath.row] = classDate
            self?.tableView.reloadRows(at: [indexPath], with: .left)
        }
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
        dates.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = rgbColor(0xffb3b8c6).withAlphaComponent(0.4)
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: scale(iPhone8Design: 22))
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 14), weight: .light)
        title.textColor = .black
        title.text = "上课时间"
        let addBtn = UIButton()
        addBtn.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-kBigTitleMargin)
            make.centerY.equalTo(view)
        }
        view.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(kBigTitleMargin)
            make.centerY.equalTo(view)
        }
        
        return view
    }
}
