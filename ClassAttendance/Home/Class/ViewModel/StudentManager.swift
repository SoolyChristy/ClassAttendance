//
// Created by SoolyChristina on 2018/4/13.
// Copyright (c) 2018 SoolyChristina. All rights reserved.
//

import Foundation
import WCDBSwift

final class StudentManager {
    static let shared = StudentManager()
    private init() {}

    public func creat(student: Student, compeletionHandler: @escaping Handler<DBError>) {
        DatabaseManager.shared.creatStudent(students: [student], compeletionHandler: compeletionHandler)
    }

    public func update(student: Student, compeletionHandler: @escaping Handler<DBError>) {
        DatabaseManager.shared.update(objects: [student], handler: compeletionHandler)
    }
    
    public func get(with IDs: [ID]) -> [Student] {
        var students = [Student]()
        for id in IDs {
            if let student: Student = get(with: id) {
                students.append(student)
            }
        }
        return students
    }
    
    public func get(with ID: ID) -> Student? {
        guard let student: Student = DatabaseManager.shared.getObject(where: Student.Properties.id == ID) else {
            printLog("查找学生失败")
            return nil
        }
        printLog("查找成功! - \(student)")
        return student
    }

    public func makeStudents() -> [ID] {
        let s1 = Student(name: "罗建武", id: 1024, phone: 13000000001, sex: Sex.male.rawValue)
        let s2 = Student(name: "奥巴马", id: 1025, phone: 13000000002, sex: Sex.male.rawValue)
        let s3 = Student(name: "特朗普", id: 1026, phone: 13000000003, sex: Sex.male.rawValue)
        let s4 = Student(name: "奥朗德", id: 1027, phone: 13000000004, sex: Sex.male.rawValue)
        let s5 = Student(name: "白百何", id: 1028, phone: 13000000005, sex: Sex.female.rawValue)
        let s6 = Student(name: "詹姆斯", id: 1029, phone: 13000000006, sex: Sex.male.rawValue)
        let s7 = Student(name: "李娜", id: 1034, phone: 13000000011, sex: Sex.female.rawValue)
        let s8 = Student(name: "邓肯", id: 1044, phone: 13000000021, sex: Sex.male.rawValue)
        let s9 = Student(name: "朴槿惠", id: 1054, phone: 13000000031, sex: Sex.female.rawValue)
        let s10 = Student(name: "刘延东", id: 1064, phone: 13000000041, sex: Sex.male.rawValue)
        let s11 = Student(name: "科比", id: 1074, phone: 13000000051, sex: Sex.male.rawValue)
        let s12 = Student(name: "库里", id: 1084, phone: 13000000061, sex: Sex.male.rawValue)
        let s13 = Student(name: "卡梅伦", id: 1094, phone: 13000000071, sex: Sex.male.rawValue)
        let s14 = Student(name: "青花瓷", id: 1095, phone: 13000000072, sex: Sex.male.rawValue)
        let s15 = Student(name: "江疏影", id: 1096, phone: 13000000073, sex: Sex.female.rawValue)
        let students = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12 ,s13, s14, s15]
        DatabaseManager.shared.creatStudent(students: students) { (result) in
            switch result {
            case .success:
                printLog("添加默认学生成功")
            case .failure(_):
                printLog("学生表已有学生")
            }
        }
        return [s1.id, s2.id, s3.id, s4.id, s5.id, s6.id, s7.id, s8.id, s9.id, s10.id, s11.id, s12.id, s13.id, s14.id, s15.id]
    }

}
