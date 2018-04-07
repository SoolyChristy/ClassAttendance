//
//  AddStudentController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/1.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class AddStudentController: BaseViewController {

    init(compeletionHandler: @escaping (Student) -> ()) {
        super.init(nibName: nil, bundle: nil)
        self.compeletionHandler = compeletionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "添加学生"
        let iconBtn = UIButton.iconButton()
        iconBtn.addTarget(self, action: #selector(iconBtnAction), for: .touchUpInside)
        view.addSubview(iconBtn)
        iconBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(scale(iPhone8Design: 20))
            make.centerX.equalTo(view)
        }
        
        nameFiled.placehoderLabel.text = "姓名"
        view.addSubview(nameFiled)
        nameFiled.snp.makeConstraints { (make) in
            make.top.equalTo(iconBtn.snp.bottom).offset(scale(iPhone8Design: 28))
            make.centerX.equalTo(view)
            make.width.equalTo(scale(iPhone8Design: 180))
            make.height.equalTo(scale(iPhone8Design: 17))
        }
        
        idFiled.placehoderLabel.text = "学号"
        view.addSubview(idFiled)
        idFiled.snp.makeConstraints { (make) in
            make.top.equalTo(nameFiled.snp.bottom).offset(kTextFieldMargin)
            make.centerX.equalTo(view)
            make.width.height.equalTo(nameFiled)
        }
        
        phoneFiled.placehoderLabel.text = "手机号码"
        view.addSubview(phoneFiled)
        phoneFiled.snp.makeConstraints { (make) in
            make.top.equalTo(idFiled.snp.bottom).offset(kTextFieldMargin)
            make.centerX.equalTo(view)
            make.width.height.equalTo(nameFiled)
        }
        
        let sexButton = UIButton.customButton(title: "性别", size: CGSize(width: scale(iPhone8Design: 180),
                                                                            height: scale(iPhone8Design: 38)))
        view.addSubview(sexButton)
        sexButton.addTarget(self, action: #selector(sexButtonAction(btn:)), for: .touchUpInside)
        sexButton.snp.makeConstraints { (make) in
            make.top.equalTo(phoneFiled.snp.bottom).offset(kTextFieldMargin)
            make.centerX.equalTo(view)
        }
        
        let doneBtn = UIButton.customButton(title: "完成")
        doneBtn.isEnabled = false
        doneBtn.addTarget(self, action: #selector(doneBtnAction), for: .touchUpInside)
        view.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { (make) in
            make.top.equalTo(sexButton.snp.bottom).offset(kCustomButtonMargin)
            make.centerX.equalTo(view)
        }
        
        nameFiled.setStatusDidChanged(self) { (weakSelf, text) in
            let flag = !text.isEmpty && !(weakSelf.idFiled.text ?? "").isEmpty && !(weakSelf.phoneFiled.text ?? "").isEmpty
            doneBtn.isEnabled = flag ? true : false
        }
        idFiled.setStatusDidChanged(self) { (weakSelf, text) in
            let flag = !text.isEmpty && !(weakSelf.nameFiled.text ?? "").isEmpty && !(weakSelf.phoneFiled.text ?? "").isEmpty
            doneBtn.isEnabled = flag ? true : false
        }
        phoneFiled.setStatusDidChanged(self) { (weakSelf, text) in
            let flag = !text.isEmpty && !(weakSelf.idFiled.text ?? "").isEmpty && !(weakSelf.nameFiled.text ?? "").isEmpty
            doneBtn.isEnabled = flag ? true : false
        }
        
    }
    
    private var compeletionHandler: (Student) -> () = {_ in }
    private var sex: Sex?
    private let nameFiled = TextFiledView.textFiledView()
    private let idFiled = TextFiledView.textFiledView()
    private let phoneFiled = TextFiledView.textFiledView()
}

extension AddStudentController {
    
    @objc private func sexButtonAction(btn: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: "请选择性别")
        alert.addAction(image: #imageLiteral(resourceName: "ic_male"), title: Sex.male.rawValue, color: maleColor, style: .default, isEnabled: true) { _ in
            btn.setTitle(Sex.male.rawValue, for: .normal)
            self.sex = .male
        }
        alert.addAction(image: #imageLiteral(resourceName: "ic_female"), title: Sex.female.rawValue, color: femaleColor, style: .default, isEnabled: true) { _ in
            btn.setTitle(Sex.female.rawValue, for: .normal)
            self.sex = .female
        }
        alert.addAction(title: "取消", style: .cancel)
        alert.show()
    }
    
    @objc private func doneBtnAction() {
        guard let id = Int(idFiled.text ?? "") else {
            view.makeToast("学号不合法！")
            return
        }
        guard let phone = Int(phoneFiled.text ?? "") else {
            view.makeToast("手机号码不合法！")
            return
        }
        guard let sex = sex else {
            view.makeToast("请选择性别")
            return
        }
        guard let name = nameFiled.text else {
            return
        }
        let icon = sex == .male ? "ic_boy" : "ic_girl"
        let student = Student(name: name, id: id, phone: phone, icon: icon, sex: sex, late: nil, absenteeism: nil, earlyLeave: nil, leave: nil)
        compeletionHandler(student)
        navigationController?.popViewController(animated: true)
    }
    @objc private func iconBtnAction() {
        
    }
}
