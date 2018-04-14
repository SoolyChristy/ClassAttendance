//
//  ClassManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/7.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import WCDBSwift

final class ClassManager {
    
    static let shared = ClassManager()

    public func creatClass(aClass: Class,
                           compeletionHandler: @escaping Handler<DBError.ClassError>) {
        DatabaseManager.shared.creatClass(aClass: aClass) { (result) in
            switch result {
            case .success:
                compeletionHandler(.success)
            case .failure(let error):
                compeletionHandler(.failure(error))
            }
        }
    }
    
    public func getAll() -> [Class]? {
        guard let user = AccountManager.shared.currentUser(),
            let classes: [Class] = DatabaseManager.shared.getObjects(where: Class.Properties.userId == user.identifier, orderBy: nil) else {
            return nil
        }
        return classes
    }
    
    public func update(_ aClass: Class, compeletionHandler: @escaping Handler<DBError>) {
        DatabaseManager.shared.update(objects: [aClass], handler: compeletionHandler)
    }

}
