//
//  CallTheRollManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/12.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import UIKit

class CallTheRollManager: NSObject {
    public var attendanceTags: [AttendanceType] = []
    public var lateList = [ID]()
    public var leaveList = [ID]()
    public var absenteeismList = [ID]()
    private let aClass: Class
    private weak var vc: UIViewController?
    
    init(target: UIViewController, aClass: Class) {
        self.aClass = aClass
        self.vc = target
        for _ in 0..<aClass.students.count {
            attendanceTags.append(.none)
        }
    }
    
    public func finishCall() {
        printLog("\n请假:\(leaveList.count)人\n迟到:\(lateList.count)人\n缺课\(absenteeismList.count)人")
        _ = leaveList.map {
            printLog("请假 - \($0)")
        }
        _ = lateList.map {
            printLog("迟到 - \($0)")
        }
        _ = absenteeismList.map {
            printLog("缺课 - \($0)")
        }
        let record = AttendanceRecord(aClass: aClass, date: Date(), info: "", late: lateList, leave: leaveList, absenteeism: absenteeismList)
        AttendanceManager.shared.create(record) { (result) in
            switch result {
            case .success:
                keyWindow?.makeToast("成功提交考勤表")
            case .failure(_):
                keyWindow?.makeToast("提交考勤表失败")
            }
        }
    }
}

extension CallTheRollManager: ClassStudentCellDelegate {
    func studentCell(_ cell: ClassStudentCell, didSelectedAttendance type: AttendanceType) {
        guard let indexPath = cell.indexPath,
            let student = cell.student else {
                return
        }
        attendanceTags[indexPath.row] = type
        switch type {
        case .none:
            if let index = lateList.index(of: student.id) {
                lateList.remove(at: index)
            } else if let index = leaveList.index(of: student.id) {
                leaveList.remove(at: index)
            } else if let index = absenteeismList.index(of: student.id) {
                absenteeismList.remove(at: index)
            }
            break
        case .absenteeism:
            if let index = lateList.index(of: student.id) {
                lateList.remove(at: index)
            } else if let index = leaveList.index(of: student.id) {
                leaveList.remove(at: index)
            }
            absenteeismList.append(student.id)
            break
        case .late:
            if let index = absenteeismList.index(of: student.id) {
                absenteeismList.remove(at: index)
            } else if let index = leaveList.index(of: student.id) {
                leaveList.remove(at: index)
            }
            lateList.append(student.id)
            break
        case .leave:
            if let index = absenteeismList.index(of: student.id) {
                absenteeismList.remove(at: index)
            } else if let index = lateList.index(of: student.id) {
                lateList.remove(at: index)
            }
            leaveList.append(student.id)
            break
        }
    }
}
