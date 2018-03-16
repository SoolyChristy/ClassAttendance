//
//  LoginViewController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapAciton))
        view.addGestureRecognizer(tap)

        let bigTitle = UILabel(bigTitle: "欢迎使用，请登录")
        view.addSubview(bigTitle)
        bigTitle.snp.makeConstraints { (make) in
            make.top.equalTo(scale(iPhone8Design: 76))
            make.left.equalTo(bigTitleMargin)
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
        
        passwordFiled.textField.delegate = self
        passwordFiled.textField.returnKeyType = .done
        view.addSubview(passwordFiled)
        passwordFiled.snp.makeConstraints { (make) in
            make.top.equalTo(nameFiled.snp.bottom).offset(scale(iPhone8Design: 24))
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.width.equalTo(nameFiled)
        }
        
        let loginBtn = UIButton.customButton(title: "登录")
        loginBtn.addTarget(self, action: #selector(loginBtnAction), for: .touchUpInside)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordFiled.snp.bottom).offset(scale(iPhone8Design: 24))
            make.centerX.equalTo(view)
        }
        
        let forgotBtn = UIButton()
        forgotBtn.setTitle("忘记密码?", for: .normal)
        forgotBtn.setTitleColor(.black, for: .normal)
        forgotBtn.titleLabel?.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 14))
        view.addSubview(forgotBtn)
        forgotBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(scale(iPhone8Design: 12))
            make.left.equalTo(loginBtn.snp.left).offset(scale(iPhone8Design: 28))
        }
        forgotBtn.sizeToFit()
        
        let registerBtn = UIButton()
        registerBtn.setTitle("注册账号", for: .normal)
        registerBtn.setTitleColor(mainColor, for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 14))
        view.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(scale(iPhone8Design: 12))
            make.right.equalTo(loginBtn.snp.right).offset(scale(iPhone8Design: -28))
        }
        registerBtn.sizeToFit()
        registerBtn.addTarget(self, action: #selector(registerBtnAction), for: .touchUpInside)
    }
    
    private let nameFiled = InputView.inputView(placeholderImage: #imageLiteral(resourceName: "ic_nickname"), placeholderText: "手机号")
    private let passwordFiled = InputView.inputView(placeholderImage: #imageLiteral(resourceName: "ic_password"), placeholderText: "密码")
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameFiled.textField {
            passwordFiled.textField.becomeFirstResponder()
        }
        return true
    }
}

extension LoginViewController {
    @objc private func loginBtnAction() {
        if let nickName = nameFiled.textField.text,
            let psw = passwordFiled.textField.text {
            AccountManager.shared.login(userName: nickName, password: psw, compeletionHandler: { (result) in
                keyWindow?.hideToast()
                switch result {
                case .success:
                    keyWindow?.makeToast("登录成功！")
                    dismiss(animated: true)
                case .failure(let error):
                    switch error {
                    case .userDoNotExist:
                        keyWindow?.makeToast("用户不存在！")
                    case .wrongPassword:
                        keyWindow?.makeToast("密码错误！")
                    default:
                        keyWindow?.makeToast("登录失败！")
                    }
                }
            })
        }
    }
    
    @objc private func registerBtnAction() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc private func viewTapAciton() {
        view.endEditing(true)
    }
}
