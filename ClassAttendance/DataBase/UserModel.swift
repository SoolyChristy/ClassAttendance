//
//  UserModel.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/13.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import WCDBSwift

public typealias ID = Int

/// 用户
struct User: TableCodable {
    var identifier: ID
    var password: String
    var userName: String
    var phoneNum: Int
    var classes: [Class]

    enum CodingKeys: String, CodingTableKey {
        typealias Root = User
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case password
        case userName
        case classes
        case phoneNum
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true),
                phoneNum: ColumnConstraintBinding(isUnique: true),
                userName: ColumnConstraintBinding(isUnique: true)
            ]
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
    
    struct ClassDate: TableCodable {
        var week: Int
        var date: Date
        enum CodingKeys: String, CodingTableKey {
            typealias Root = ClassDate
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case week
            case date
        }
    }
    var id: String
    var userId: ID
    var name: String
    var lesson: String
    var icon: String
    var dates: [ClassDate]
    var students: [ID]
    var lateCount: Int
    var leaveCount: Int
    var absenteeismCount: Int
    var records: [AttendanceRecord]?
    
    init(name: String, lesson: String, icon: String, dates: [ClassDate], students: [ID]) {
        self.id = name + lesson
        self.userId = AccountManager.shared.currentUser()?.identifier ?? 0
        self.name = name
        self.lesson = lesson
        self.icon = icon
        self.dates = dates
        self.students = students
        self.lateCount = 0
        self.leaveCount = 0
        self.absenteeismCount = 0
        self.records = [AttendanceRecord]()
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Class
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id
        case userId
        case name
        case dates
        case icon
        case students
        case lesson
        case lateCount
        case leaveCount
        case absenteeismCount
        case records
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [id: ColumnConstraintBinding(isPrimary: true)]
        }
    }
}

/// 学生
struct Student: TableCodable {
    var name: String
//    var classId: String
    var id: ID
    var phone: Int
    var icon: String
    var sex: String
    var absenteeismCount: Int
    var lateCount: Int
    var leaveCount: Int

    init(name: String, id: ID, phone: Int, icon: String = "ic_boy", sex: String) {
        self.name = name
        self.id = id
        self.phone = phone
        self.icon = icon
        self.sex = sex
        self.absenteeismCount = 0
        self.lateCount = 0
        self.leaveCount = 0
    }

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Student
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name
        case id
//        case classId
        case phone
        case icon
        case sex
        case absenteeismCount
        case lateCount
        case leaveCount

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [id: ColumnConstraintBinding(isPrimary: true)]
        }
    }
}

/// 考勤表
struct AttendanceRecord: TableCodable {
    var classId: String
    var className: String
    var lessonName: String
    var date: Date
    var info: String
    var late: [ID]
    var leave: [ID]
    var absenteeism: [ID]
    
    init(aClass: Class, date: Date, info: String, late: [ID], leave: [ID], absenteeism: [ID]) {
        self.classId = aClass.id
        self.className = aClass.name
        self.lessonName = aClass.lesson
        self.date = date
        self.info = info
        self.late = late
        self.leave = leave
        self.absenteeism = absenteeism
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = AttendanceRecord
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case classId
        case className
        case lessonName
        case date
        case info
        case late
        case leave
        case absenteeism
    }
}

struct AttendanceDetail {
    let records: [AttendanceRecord]
    let lateCount: Int
    let leaveCount: Int
    let absenteeismCount: Int
}

enum Sex: String, TableCodable {
    case male = "男"
    case female = "女"
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sex
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case male
        case female
    }
}

public enum AttendanceType: Int {
    case none = 0
    case late
    case leave
    case absenteeism
}

extension AttendanceType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "正常出勤"
        case .late:
            return "迟到"
        case .leave:
            return "请假"
        case .absenteeism:
            return "缺课"
        }
    }
    
}

