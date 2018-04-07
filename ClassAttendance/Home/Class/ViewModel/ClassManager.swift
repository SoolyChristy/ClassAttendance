//
//  ClassManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/7.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation

final class ClassManager {
    public func creatClass(name: String,
                           lesson: String,
                           dates: [ClassDate],
                           compeletionHandler: @escaping Handler<DBError.ClassError>) {
        let aClass = Class(id: "\(name)\(lesson)",
            name: name,
            lesson: lesson,
            icon: "ic_defalut_class",
            dates: dates,
            students: [Student](),
            attendanceSheets: nil)
        DatabaseManager.shared.creatClass(aClass: aClass, compeletionHandler: compeletionHandler)
    }
}
