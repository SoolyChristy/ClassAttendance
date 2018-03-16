//
//  DataBaseManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/15.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import WCDBSwift

private let kDataBasePath = documentsPath + "/dataBase.db"
private let kUserTableName = "User"
private let kLessonTableName = "Lesson"
private let kClassTabelName = "Class"
private let kAttendanceRecordName = "AttendanceRecord"

class DataBaseManager {
    public static let shared = DataBaseManager()
    
    private let dataBase = Database(withPath: kDataBasePath)
    private init() {}

    public func appFinishLaunching() {
        creatTables()
        creatUser(identifier: 10014, userName: "罗建武", phoneNum: 13163690098, password: "1234455")
        getUser()
    }
    
    private func getUser() {
        guard let user: [User] = try? dataBase.getObjects(fromTable: kUserTableName) else {
            printLog("没有User")
            return
        }
        printLog(user)
    }
}

extension DataBaseManager {

    public func creatUser(identifier: Int, userName: String, phoneNum: Int, password: String) {
        let user = User(identifier: identifier, password: password, userName: userName, phoneNum: phoneNum, classes: [Class]())
        insert(objects: [user], intoTable: kUserTableName)
    }
    
    public func creatLesson(id: Int, name: String) {
        let lesson = Lesson(name: name, id: id)
        insert(objects: [lesson], intoTable: kLessonTableName)
    }
    
    public func creatClass(name: String, lesson: String, students: [Student]?, attendanceSheets: [AttendanceRecord]?) {
        let aClass = Class(name: name, lesson: lesson, students: students, attendanceSheets: attendanceSheets)
        insert(objects: [aClass], intoTable: kClassTabelName)
    }
}

extension DataBaseManager {

    private func creatTables() {
        do {
            try dataBase.create(table: kUserTableName, of: User.self)
            try dataBase.create(table: kLessonTableName, of: Lesson.self)
            try dataBase.create(table: kAttendanceRecordName, of: AttendanceRecord.self)
            try dataBase.create(table: kClassTabelName, of: Class.self)
        } catch let error {
            printLog(error)
        }
    }

    private func insert<Object: TableEncodable>(objects: [Object], intoTable: String) {
        do {
            try dataBase.insert(objects: objects, intoTable: intoTable)
        } catch let error {
            printLog(error)
        }
    }
}
