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

        var classList = [Class]()
        for aClass in classes {
            var cl = aClass
            let detail = AttendanceManager.shared.getAttendanceDetail(with: cl.id)
            cl.absenteeismCount = detail.absenteeismCount
            cl.leaveCount = detail.leaveCount
            cl.lateCount = detail.lateCount
            cl.records = detail.records
            classList.append(cl)
        }
        return classList
    }
    
    public func getToday(from classes: [Class]) -> [Class] {
        var todayClasses = [Class]()
        let weekDay = DateUtils.getWeekDay()
        for aClass in classes {
            for classDate in aClass.dates {
                if weekDay == classDate.week {
                    todayClasses.append(aClass)
                    break
                }
            }
        }
        printLog("查询今天的课程 - 查到\(todayClasses.count)条结果")
        return todayClasses
    }
    
    public func update(_ aClass: Class, compeletionHandler: @escaping Handler<DBError>) {
        DatabaseManager.shared.update(objects: [aClass], handler: compeletionHandler)
    }

}
