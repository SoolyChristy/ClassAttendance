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
private let kClassTabelName = "Class"
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
    
    public func creatLesson(id: Int, name: String, compeletionHandler: Handler<Swift.Error>?) {
        let lesson = Lesson(name: name, id: id)
        insert(objects: [lesson], intoTable: kLessonTableName, handler: compeletionHandler)
    }
    
    public func creatClass(aClass: Class, compeletionHandler: @escaping Handler<DBError.ClassError>) {
        insert(objects: [aClass], intoTable: kClassTabelName) { (result) in
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
}

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
}

extension DatabaseManager {

    private func creatTables() {
        do {
            try dataBase.create(table: kUserTableName, of: User.self)
            try dataBase.create(table: kLessonTableName, of: Lesson.self)
            try dataBase.create(table: kAttendanceRecordName, of: AttendanceRecord.self)
            try dataBase.create(table: kClassTabelName, of: Class.self)
        } catch let error {
            printLog("创建表失败 - \(error)")
        }
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
}
