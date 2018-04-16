//
//  AttendanceManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import WCDBSwift

class AttendanceManager: ManagerProtocol {
    
    static let shared = AttendanceManager()
    private init () {}
    
    func getAll() -> [AttendanceRecord]? {
        guard let records: [AttendanceRecord] = DatabaseManager.shared.getObjects(where: nil, orderBy: [AttendanceRecord.Properties.date.asOrder(by: .descending)]) else {
            printLog("查找所有考勤表失败")
            return nil
        }
        printLog("查找所有考勤表成功 - 查到\(records.count)条记录")
        return records
    }
    
    func getRecords(with classId: ClassID) -> [AttendanceRecord]? {
        guard let records: [AttendanceRecord] = DatabaseManager.shared.getObjects(where: AttendanceRecord.Properties.classId == classId, orderBy: nil) else {
            printLog("没有找到符合要求的考勤表")
            return nil
        }
        printLog("查找考勤表成功 - 查到\(records.count)条结果")
        return records
    }

    func get(with IDs: [IDType]) -> [AttendanceRecord] {
        fatalError("this method can not be called")
    }
    
    func get(with ID: IDType) -> AttendanceRecord? {
        fatalError("this method can not be called")
    }

    func create(_ model: AttendanceRecord, compeletionHandler: @escaping (Result<DBError>) -> ()) {
        DatabaseManager.shared.createAttendanceRecord(record: model, compeletionHandler: compeletionHandler)
    }

    func update(_ model: AttendanceRecord, compeletionHandler: @escaping (Result<DBError>) -> ()) {
        DatabaseManager.shared.update(objects: [model], handler: compeletionHandler)
    }

    func delete(_ model: AttendanceRecord, compeletionHandler: @escaping (Result<DBError>) -> ()) {
        
    }

    typealias Model = AttendanceRecord
    typealias IDType = String
    typealias ClassID = String

}

extension AttendanceManager {

    public func getAttendanceDetail(with classID: ClassID) -> AttendanceDetail {
        guard let records = getRecords(with: classID) else {
            return AttendanceDetail(records: [AttendanceRecord](), lateCount: 0, leaveCount: 0, absenteeismCount: 0)
        }
        var lateCount = 0
        var leaveCount = 0
        var absenteeismCount = 0
        for record in records {
            lateCount += record.late.count
            leaveCount += record.leave.count
            absenteeismCount += record.absenteeism.count
        }
        return AttendanceDetail(records: records, lateCount: lateCount, leaveCount: leaveCount, absenteeismCount: absenteeismCount)
    }
}

