//
//  SignUpViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapAciton))
        view.addGestureRecognizer(tap)
        view.backgroundColor = .white
        let bigTitle = UILabel(bigTitle: "注册")
        view.addSubview(bigTitle)
        bigTitle.snp.makeConstraints { (make) in
            make.top.equalTo(scale(iPhone8Design: 76))
            make.left.equalTo(kBigTitleMargin)
        }
        
        nameFiled.textField.delegate = self
        nameFiled.textField.returnKeyType = .next
        view.addSubview(nameFiled)
        nameFiled.snp.makeConstraints { (make) in
            make.top.equalTo(bigTitle.snp.bottom).offset(scale(iPhone8Design: 80))
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.width.equalTo(scale(iPhone8Design: 280))
        }
        
        phoneFiled.textField.delegate = self
        phoneFiled.textField.returnKeyType = .next
        phoneFiled.textField.keyboardType = .phonePad
        view.addSubview(phoneFiled)
        phoneFiled.snp.makeConstraints { (make) in
            make.top.equalTo(nameFiled.snp.bottom).offset(scale(iPhone8Design: 24))
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.width.equalTo(nameFiled)
        }
        
        passwordFiled.textField.delegate = self
        passwordFiled.textField.isSecureTextEntry = true
        passwordFiled.textField.returnKeyType = .done
        view.addSubview(passwordFiled)
        passwordFiled.snp.makeConstraints { (make) in
            make.top.equalTo(phoneFiled.snp.bottom).offset(scale(iPhone8Design: 24))
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.width.equalTo(nameFiled)
        }
        
        let signUpBtn = UIButton.customButton(title: "注册")
        view.addSubview(signUpBtn)
        signUpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordFiled.snp.bottom).offset(scale(iPhone8Design: 56))
            make.centerX.equalTo(view)
        }
        signUpBtn.addTarget(self, action: #selector(signUpBtnAction), for: .touchUpInside)
        
        let tipBtn = UIButton()
        tipBtn.setTitle("已有一个账户了吗?", for: .normal)
        tipBtn.setTitleColor(.black, for: .normal)
        tipBtn.titleLabel?.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 14))
        tipBtn.addTarget(self, action: #selector(tipBtnAction), for: .touchUpInside)
        view.addSubview(tipBtn)
        tipBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signUpBtn.snp.bottom).offset(scale(iPhone8Design: 14))
            make.centerX.equalTo(view)
        }
    }
    
    private let nameFiled = InputView.inputView(placeholderImage: #imageLiteral(resourceName: "ic_nickname"), placeholderText: "用户名")
    private let phoneFiled = InputView.inputView(placeholderImage: #imageLiteral(resourceName: "ic_phone"), placeholderText: "手机号")
    private let passwordFiled = InputView.inputView(placeholderImage: #imageLiteral(resourceName: "ic_password"), placeholderText: "密码")
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameFiled.textField:
            phoneFiled.textField.becomeFirstResponder()
        case phoneFiled.textField:
            passwordFiled.textField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
}

extension SignUpViewController {
    
    @objc private func viewTapAciton() {
        view.endEditing(true)
    }
    
    @objc private func signUpBtnAction() {
        if let name = nameFiled.textField.text,
            let phoneStr = phoneFiled.textField.text,
            let phone = Int(phoneStr),
            let psw = passwordFiled.textField.text {
            AccountManager.shared.register(userName: name, phoneNum: phone, password: psw, compeletionHandler: { (result) in
                switch result {
                case .success:
                    keyWindow?.makeToast("注册成功！")
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    var info = ""
                    switch error {
                    case .nickNameRepeat:
                        info = "用户名重复"
                    case .phoneNumRepeat:
                        info = "手机号重复"
                    default:
                        info = "注册失败！请稍后重试"
                    }
                    self.view.hideToast()
                    self.view.makeToast(info)
                }
            })
        }
    }
    
    @objc private func tipBtnAction() {
        navigationController?.popViewController(animated: true)
    }
}
