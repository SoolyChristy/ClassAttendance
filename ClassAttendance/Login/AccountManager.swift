//
//  AccountManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/15.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import UIKit

private let kCurrentAccountKey = "currentAccount"

class AccountManager {
    static let shared = AccountManager()
    
    public var currentUser: User? = {
        guard let id = UserDefaults.standard.object(forKey: kCurrentAccountKey) as? Int else {
            return nil
        }
        return DatabaseManager.shared.getUser(identifier: id)
    }()
    
    public func appFinishLaunching() {
        guard let _ = currentUser else {
            let loginVc = NavViewController(rootViewController: LoginViewController())
            keyWindow?.rootViewController?.present(loginVc, animated: false)
            return
        }
    }
    
    public func register(userName: String, phoneNum: Int, password: String, compeletionHandler: @escaping Handler<DBError.AccountError>) {
        DatabaseManager.shared.creatUser(identifier: phoneNum,
                                         userName: userName,
                                         phoneNum: phoneNum,
                                         password: password,
                                         compeletionHandler: compeletionHandler)
    }
    
    public func login(userName: String, password: String, compeletionHandler: Handler<DBError.AccountError>) {
        if let phoneNum = Int(userName) {
            DatabaseManager.shared.checkUser(identifier: phoneNum, password: password, handler: { (result) in
                switch result {
                case .success:
                    UserDefaults.standard.set(phoneNum, forKey: kCurrentAccountKey)
                    compeletionHandler(.success)
                case .failure(let error):
                    compeletionHandler(.failure(error))
                }
            })
        } else {
            compeletionHandler(.failure(.userIsNotLegal))
        }
    }

    private init() {}
    
}
