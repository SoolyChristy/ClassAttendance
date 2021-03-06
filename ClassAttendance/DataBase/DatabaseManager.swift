//
//  DatabaseManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/15.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import WCDBSwift

private let kDataBasePath = kDocumentsPath + "/dataBase.db"
private let kUserTableName = "User"
private let kLessonTableName = "Lesson"
private let kClassTableName = "Class"
private let kStudentTableName = "Student"
private let kAttendanceRecordName = "AttendanceRecord"

public enum DBError {
    public enum AccountError {
        case nickNameRepeat
        case phoneNumRepeat
        case userDoNotExist
        case userIsNotLegal
        case wrongPassword
        case unknown
    }
    
    public enum ClassError {
        case idRepeat
        case updateError
        case unknown
    }
    
    case updateError
    case objectIsNotLegal
    case unknown
}

public enum Result<ErrorType> {
    case success
    case failure(ErrorType)
}

public typealias Handler<ErrorType> = (Result<ErrorType>) -> ()

class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let dataBase = Database(withPath: kDataBasePath)
    private init() {}

    public func appFinishLaunching() {
        creatTables()
    }
}

// MARK: 创建表
extension DatabaseManager {

    public func creatUser(identifier: Int,
                          userName: String,
                          phoneNum: Int,
                          password: String,
                          compeletionHandler: @escaping Handler<DBError.AccountError>) {
        let user = User(identifier: identifier, password: password, userName: userName, phoneNum: phoneNum, classes: [Class]())
        insert(objects: [user], intoTable: kUserTableName) { (result) in
            switch result {
            case .success:
                printLog("创建用户成功 - \(user)")
                compeletionHandler(.success)
            case .failure(let error):
                printLog("创建用户失败 - \(error)")
                var dbError: DBError.AccountError = .unknown
                if let errorMsg = (error as? WCDBSwift.Error)?.message{
                    if errorMsg.contains("User.userName") {
                        dbError = .nickNameRepeat
                    } else if errorMsg.contains("User.identifier") {
                        dbError = .phoneNumRepeat
                    }
                }
                compeletionHandler(.failure(dbError))
            }
        }
    }
    
    public func creatStudent(students: [Student], compeletionHandler: @escaping Handler<DBError>) {
        insert(objects: students, intoTable: kStudentTableName) { result in
            switch result {
                case .success:
                    printLog("创建学生成功！ -\(students)")
                    compeletionHandler(.success)
                case .failure(let error):
                    printLog("创建学生失败！ - \(error)")
                    let dbError: DBError = .unknown
                    compeletionHandler(.failure(dbError))
            }
         }
    }
    
    public func creatClass(aClass: Class, compeletionHandler: @escaping Handler<DBError.ClassError>) {
        insert(objects: [aClass], intoTable: kClassTableName) { (result) in
            switch result {
            case .success:
                printLog("创建课堂成功 - \(aClass)")
                compeletionHandler(.success)
            case .failure(let error):
                printLog("创建课堂失败 - \(error.localizedDescription)")
                var dbError: DBError.ClassError = .unknown
                if let errorMsg = (error as? WCDBSwift.Error)?.message{
                    if errorMsg.contains("Class.id") {
                        dbError = .idRepeat
                    }
                }
                compeletionHandler(.failure(dbError))
            }
        }
    }
    
    public func createAttendanceRecord(record: AttendanceRecord, compeletionHandler: @escaping Handler<DBError>) {
        insert(objects: [record], intoTable: kAttendanceRecordName) { (result) in
            switch result {
            case .success:
                printLog("创建考勤表成功 - \(record)")
                compeletionHandler(.success)
            case .failure(let error):
                printLog("创建考勤表失败 - \(error)")
                let dbError: DBError = .unknown
                compeletionHandler(.failure(dbError))
            }
        }
    }
}

// MARK: 用户
extension DatabaseManager {
    public func getUser(identifier: Int) -> User? {
        do {
            let user: User? = try dataBase.getObject(fromTable: kUserTableName, where: User.Properties.identifier == identifier)
            return user
        } catch {
            printLog(error)
            return nil
        }
    }
    
    public func checkUser(identifier: Int, password: String, handler: Handler<DBError.AccountError>) {
        do {
            guard let user: User = try dataBase.getObject(fromTable: kUserTableName,
                                                       where: (User.Properties.identifier == identifier) && (User.Properties.phoneNum == identifier)) else {
                                                        handler(.failure(.userDoNotExist))
                                                        return
            }
            if user.password == password {
                handler(.success)
            } else {
                handler(.failure(.wrongPassword))
            }
        } catch let error {
            printLog(error)
        }
    }
}

// MARK: 删除
extension DatabaseManager {
    public func delete<Object: TableCodable>(table: Object.Type, where condition: Condition, handler: @escaping Handler<DBError>) {
        guard let tableName = getTabel(Object: table) else {
            printLog("tableType不合法")
            return
        }
        delete(fromTable: tableName, where: condition) { (result) in
            switch result {
            case .success:
                printLog("删除成功!")
                handler(.success)
            case .failure(let error):
                printLog("删除失败! - \(error)")
                let dbError: DBError = .unknown
                handler(.failure(dbError))
            }
        }
    }
}

// MARK: 查找
extension DatabaseManager {

    public func getObject<Object: TableCodable>(where condition: WCDBSwift.Condition?) -> Object? {
        guard let tableName = getTabel(Object: Object.self) else {
            printLog("查找失败 - Object不合法")
            return nil
        }
        do {
            let object: Object? = try dataBase.getObject(fromTable: tableName, where: condition)
            return object
        } catch let error {
            printLog("查找失败 - \(error)")
            return nil
        }
    }
    
    public func getObjects<Object: TableCodable>(where condition: WCDBSwift.Condition?, orderBy: [OrderBy]?) -> [Object]? {
        guard let tableName = getTabel(Object: Object.self) else {
            printLog("查找失败 - Object不合法")
            return nil
        }
        do {
            let objects: [Object] = try dataBase.getObjects(fromTable: tableName, where: condition, orderBy: orderBy)
            printLog("查找成功 - 查到\(objects.count)条结果")
            return objects
        } catch let error {
            printLog("查找失败 - \(error)")
            return nil
        }
    }
}

// MARK: 更新
extension DatabaseManager {
    
    public func update(user: User, compeletionHandler: @escaping Handler<DBError>) {
        inserOrReplace(objects: [user], intoTable: kUserTableName) { (result) in
            switch result {
            case .success:
                printLog("更新用户成功！ - \(user)")
                compeletionHandler(.success)
            case .failure(let error):
                printLog("更新用户失败！ - \(error.localizedDescription)")
                compeletionHandler(.failure(.unknown))
            }
        }
    }
    
    public func update<object: TableEncodable>(objects: [object], handler: @escaping Handler<DBError>) {
        guard let table = getTabel(Object: object.self) else {
            let error = DBError.objectIsNotLegal
            handler(.failure(error))
            return
        }
        inserOrReplace(objects: objects, intoTable: table) { (result) in
            switch result {
            case .success:
                printLog("更新数据成功! - \(objects)")
                handler(.success)
            case .failure(let error):
                printLog("更新数据失败！ - \(error)")
                handler(.failure(.updateError))
            }
        }
    }
}

// MARK: Private方法
extension DatabaseManager {

    private func creatTables() {
        do {
            try dataBase.create(table: kStudentTableName, of: Student.self)
            try dataBase.create(table: kUserTableName, of: User.self)
            try dataBase.create(table: kLessonTableName, of: Lesson.self)
            try dataBase.create(table: kAttendanceRecordName, of: AttendanceRecord.self)
            try dataBase.create(table: kClassTableName, of: Class.self)
        } catch let error {
            printLog("创建表失败 - \(error)")
        }
    }
    
    private func getTabel<Object: TableEncodable>(Object: Object.Type) -> String? {
        var table: String?
        if Object.self == Class.self {
            table = kClassTableName
        } else if Object.self == User.self {
            table = kUserTableName
        } else if Object.self == AttendanceRecord.self {
            table = kAttendanceRecordName
        } else if Object.self == Student.self {
            table = kStudentTableName
        }
        return table
    }

    private func insert<Object: TableEncodable>(objects: [Object], intoTable: String, handler: Handler<Swift.Error>?) {
        do {
            try dataBase.insert(objects: objects, intoTable: intoTable)
            handler?(.success)
        } catch let error {
            handler?(.failure(error))
        }
    }
    
    private func inserOrReplace<Object: TableEncodable>(objects: [Object], intoTable: String, handler: Handler<Swift.Error>?) {
        do {
            try dataBase.insertOrReplace(objects: objects, intoTable: intoTable)
            handler?(.success)
        } catch let error {
            handler?(.failure(error))
        }
    }
    
    private func delete(fromTable: String, where condition: Condition?, handler: Handler<Swift.Error>) {
        do {
            try dataBase.delete(fromTable: fromTable, where: condition, orderBy: nil, limit: nil, offset: nil)
            handler(.success)
        } catch let error {
            handler(.failure(error))
        }
    }
}
