//
//  ClassTimeManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/26.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import UIKit

final class classTimeManager: NSObject {
    
    typealias Compeletion = (_ date: ClassDate) -> ()
    private let weeks = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    public func showClassTimePicker(compeletion: @escaping Compeletion) {
        handler = compeletion
        showWeekPicker()
    }
    
    private func showWeekPicker() {
        weekAlert.show()
    }
    
    private func showTimePicker() {
        timeAlert.show()
    }
    
    private var selectedWeek: String?
    private var selectedDate: Date?
    
    private lazy var weekAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "请选择上课时间", preferredStyle: .actionSheet)
        alert.addPickerView(values: [weeks], action: { [weak self] (_, _, index, _) in
            self?.selectedWeek = self?.weeks[index.row]
            self?.timeAlert.title = self?.selectedWeek
        })
        alert.addAction(title: "下一步", style: .default) { [weak self] ( _) in
            printLog("下一步")
            self?.showTimePicker()
        }
        alert.addAction(title: "取消", style: .cancel)
        return alert
    }()
    
    private lazy var timeAlert: UIAlertController = {
        let alert = UIAlertController(title: selectedWeek, message: "请选择课堂开始时间", preferredStyle: .actionSheet)
        alert.addDatePicker(mode: .time, date: Date()) { [weak self] (date) in
            self?.selectedDate = date
        }
        alert.addAction(title: "上一步", style: .default) { [weak self] ( _) in
            printLog("上一步")
            self?.showWeekPicker()
        }
        alert.addAction(title: "完成", style: .cancel) { [weak self] ( _) in
            if let classDate = self?.classDate() {
                printLog("选择时间完成 - \(classDate)")
                self?.handler(classDate)
            }
        }
        return alert
    }()
    
    private var handler: Compeletion = {_ in }
}

extension classTimeManager {
    private func classDate() -> ClassDate {
        guard let selectedWeek = selectedWeek,
            let date = selectedDate else {
                return [:]
        }
        for (i, week) in weeks.enumerated() {
            if week == selectedWeek {
                return [i + 1 : date]
            }
        }
        return [:]
    }
}
