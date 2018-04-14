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
        guard let records: [AttendanceRecord] = DatabaseManager.shared.getObjects(where: nil, orderBy: nil) else {
            printLog("查找所有考勤表失败")
            return nil
        }
        printLog("查找所有考勤表成功 - 查到\(records.count)条记录")
        return records
    }
    
    func get(with ID: IDType) -> AttendanceRecord? {
        guard let record: AttendanceRecord = DatabaseManager.shared.getObject(where: AttendanceRecord.Properties.classId == ID) else {
            printLog("查找考勤表失败")
            return nil
        }
        printLog("查找考勤表成功！ - \(record)")
        return record
    }

    func get(with IDs: [IDType]) -> [AttendanceRecord] {
        var records = [AttendanceRecord]()
        for id in IDs {
            if let record = get(with: id) {
                records.append(record)
            }
        }
        return records
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

}

