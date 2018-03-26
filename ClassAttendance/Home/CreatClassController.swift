//
//  CreatClassViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/18.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

private let rowHeight = scale(iPhone8Design: 44)
private let reuseId = "creatClass.id"

class CreatClassController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "新建课堂"

        let iconBtn = UIButton()
        iconBtn.addTarget(self, action: #selector(iconBtnAction), for: .touchUpInside)
        iconBtn.setImage(#imageLiteral(resourceName: "ic_add_class"), for: .normal)
        view.addSubview(iconBtn)
        iconBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(scale(iPhone8Design: 20))
            make.centerX.equalTo(view)
            make.width.height.equalTo(scale(iPhone8Design: 71))
        }
        
        nameFiled.placehoderLabel.text = "班级名称"
        nameFiled.setStatusDidChanged(self) { (weakSelf, text) in
            weakSelf.nextBtn.isEnabled = (!text.isEmpty && !(weakSelf.lessonFiled.text ?? "").isEmpty) ? true : false
        }
        view.addSubview(nameFiled)
        nameFiled.snp.makeConstraints { (make) in
            make.top.equalTo(iconBtn.snp.bottom).offset(scale(iPhone8Design: 28))
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
            make.top.equalTo(nameFiled.snp.bottom).offset(scale(iPhone8Design: 28))
            make.centerX.equalTo(view)
            make.width.equalTo(nameFiled)
            make.height.equalTo(nameFiled)
        }
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(lessonFiled.snp.bottom).offset(scale(iPhone8Design: 28))
            make.left.right.equalTo(view)
            make.height.equalTo(44)
        }
        
        
        nextBtn.isEnabled = false
        nextBtn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(scale(iPhone8Design: 68))
            make.centerX.equalTo(view)
        }
    }
    
    fileprivate let nameFiled = TextFiledView.textFiledView()
    fileprivate let lessonFiled = TextFiledView.textFiledView()
    fileprivate let nextBtn = UIButton.customButton(title: "下一步")
    private var dates = [[Date: Int]]()
    private let classTimeMgr = classTimeManager()
}

extension CreatClassController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreatClassController {
    @objc private func nextBtnAction() {
        
    }
    
    @objc private func iconBtnAction() {
        
    }
    
    @objc private func addBtnAction() {
        classTimeMgr.showClassTimePicker { (classDate) in
            
        }
    }
}

extension CreatClassController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = rgbColor(0xffb3b8c6).withAlphaComponent(0.4)
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: scale(iPhone8Design: 22))
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15), weight: .light)
        title.textColor = .black
        title.text = "上课时间"
        let addBtn = UIButton()
        addBtn.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-bigTitleMargin)
            make.centerY.equalTo(view)
        }
        view.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(bigTitleMargin)
            make.centerY.equalTo(view)
        }
        
        return view
    }
}
