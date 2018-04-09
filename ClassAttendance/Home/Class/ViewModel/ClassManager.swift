//
//  ClassManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/7.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation

final class ClassManager {
    
    static let shared = ClassManager()

    public func creatClass(aClass: Class,
                           compeletionHandler: @escaping Handler<DBError.ClassError>) {
        DatabaseManager.shared.creatClass(aClass: aClass) { (result) in
            switch result {
            case .success:
                guard var currentUser = AccountManager.shared.currentUser else {
                    fatalError("创建课堂出错 - 数据库出错(拿不到用户)")
                }
                currentUser.classes.append(aClass)
                AccountManager.shared.update(currentUser, compeletionHandler: { (result) in
                    switch result {
                    case .success:
                        compeletionHandler(.success)
                    case .failure(_):
                        compeletionHandler(.failure(.updateError))
                    }
                })
            case .failure(let error):
                compeletionHandler(.failure(error))
            }
        }
    }
    
    public func updateClasses() {
        
    }
}
