//
//  UserModel.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/13.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import WCDBSwift

/// 用户
struct User: TableCodable {
    var identifier: Int?
    var password: String?
    var userName: String?
    var phoneNum: Int?
    var classes: [Class]?

    enum CodingKeys: String, CodingTableKey {
        typealias Root = User
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case password
        case userName
        case classes
        case phoneNum
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [identifier: ColumnConstraintBinding(isPrimary: true)]
        }
    }
}

/// 课程
struct Lesson: TableCodable {
    var name: String?
    var id: Int?

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Lesson
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name
        case id

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [name: ColumnConstraintBinding(isPrimary: true)]
        }
    }
}

/// 班级
struct Class: TableCodable {
    var name: String?
    var lesson: String?
    var students: [Student]?
    var attendanceSheets: [AttendanceRecord]?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Class
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name
        case students
        case lesson
        case attendanceSheets
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [name: ColumnConstraintBinding(isPrimary: true)]
        }
    }
}

/// 学生
struct Student: TableCodable {
    var name: String?
    var id: Int?
    var icon: String?
    var late: [AttendanceDetail]?
    var absenteeism: [AttendanceDetail]?
    var earlyLeave: [AttendanceDetail]?
    var leave: [AttendanceDetail]?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Student
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name
        case id
        case icon
        case late
        case absenteeism
        case earlyLeave
        case leave
    }
}

/// 考勤原因
struct AttendanceDetail: TableCodable {
    var date: Date?
    var info: String?

    enum CodingKeys: String, CodingTableKey {
        typealias Root = AttendanceDetail
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case date
        case info
    }
}

/// 考勤表
struct AttendanceRecord: TableCodable {
    var date: Date?
    var info: String?
    var late: [Student]?
    var leave: [Student]?
    var earlyLeave: [Student]?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = AttendanceRecord
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case date
        case info
        case late
        case leave
        case earlyLeave
    }
}

//struct RecordDetail: TableCodable {
////    var student: Student?
//    var test: String
//
//    enum CodingKeys: String, CodingTableKey {
//        typealias Root = RecordDetail
//        static let objectRelationalMapping = TableBinding(CodingKeys.self)
////        case student
//        case test
//    }
//}

